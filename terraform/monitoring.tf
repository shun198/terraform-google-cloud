# resource "google_monitoring_alert_policy" "events_transform" {
#   combiner              = "OR"
#   display_name          = "events_transform"
#   enabled               = true
#   notification_channels = [data.google_monitoring_notification_channel.notify_channel.name]
#   project               = var.project
#   severity              = "ERROR"
#   user_labels           = {}
#   alert_strategy {
#     auto_close = "3600s"
#   }
#   conditions {
#     display_name = "Cloud Run Job - Completed exit result and task attempts"
#     condition_threshold {
#       comparison              = "COMPARISON_GT"
#       denominator_filter      = null
#       duration                = "0s"
#       evaluation_missing_data = null
#       filter                  = "resource.type = \"cloud_run_job\" AND resource.labels.job_name = \"transform\" AND metric.type = \"run.googleapis.com/job/completed_task_attempt_count\" AND metric.labels.result = \"failed\""
#       threshold_value         = 0

#       aggregations {
#         alignment_period     = "3600s"
#         cross_series_reducer = null
#         group_by_fields      = []
#         per_series_aligner   = "ALIGN_SUM"
#       }

#       trigger {
#         count   = 1
#         percent = 0
#       }
#     }
#   }
#   documentation {
#     content   = "### transform error\n\n#### Summary\n\nデータの加工処理が失敗しました\n\n#### Additional resource information\n\nhttps://console.cloud.google.com/run/jobs/details/${var.region}/transform/logs?project=$${resource.project}\n"
#     mime_type = "text/markdown"
#     subject   = null
#   }
# }

# resource "google_monitoring_alert_policy" "request-alert-policy" {
#   display_name = "SLO burn rate alert request"
#   combiner     = "AND"
#   conditions {
#     display_name = "SLO burn rate request with long window"
#     condition_threshold {
#       filter          = "select_slo_burn_rate(\"${google_monitoring_slo.events_request_slo.name}\", 60m)"
#       threshold_value = "10"
#       duration        = "0s"
#       comparison      = "COMPARISON_GT"
#     }
#   }
#   project               = var.project
#   notification_channels = [data.google_monitoring_notification_channel.notify_channel.name]
# }

# resource "google_monitoring_slo" "events_request_slo" {
#   calendar_period = "DAY"
#   display_name    = "EVENTS_REQUEST_SLO 90% - Availability - Calendar day"
#   goal            = 0.9
#   project         = var.project
#   service         = google_monitoring_service.request_service.service_id
#   slo_id          = "events_request_slo"
#   user_labels     = {}
#   basic_sli {
#     location = []
#     method   = []
#     version  = []
#     availability {
#       enabled = true
#     }
#   }
# }

# resource "google_monitoring_service" "request_service" {
#   display_name = "request_service"
#   project      = var.project
#   service_id   = "request_service"
#   user_labels  = {}
#   basic_service {
#     service_labels = {
#       location     = var.region
#       service_name = "request"
#     }
#     service_type = "CLOUD_RUN"
#   }
# }

# https://cloud.google.com/monitoring/support/notification-options?hl=ja
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/monitoring_notification_channel
data "google_monitoring_notification_channel" "notify_channel" {
  display_name = "gcloud-monitoring"
  project      = var.project
}

# scheduled queryのtransfer_config_idのみを抽出
locals {
  icu_tc_array = split("/", google_bigquery_data_transfer_config.insert_coupon_usage_query.id)
  icu_tc_id    = element(local.icu_tc_array, length(local.icu_tc_array) - 1)
}

resource "google_monitoring_alert_policy" "alert_insert_coupon_usage" {
  combiner              = "OR"
  display_name          = "alert-insert-coupon-usage"
  enabled               = true
  notification_channels = [data.google_monitoring_notification_channel.notify_channel.name]
  project               = var.project
  severity              = "ERROR"
  user_labels           = {}
  alert_strategy {
    auto_close = "3600s"
  }
  conditions {
    display_name = "Scheduled Query [insert coupon usage] - Completed Executions"

    condition_threshold {
      comparison              = "COMPARISON_GT"
      denominator_filter      = null
      duration                = "0s"
      evaluation_missing_data = null
      filter                  = "resource.type = \"bigquery_dts_config\" AND resource.labels.config_id = \"${local.icu_tc_id}\" AND metric.type = \"bigquerydatatransfer.googleapis.com/transfer_config/completed_runs\" AND metric.labels.completion_state = \"FAILED\""
      threshold_value         = 0

      aggregations {
        alignment_period     = "3600s"
        cross_series_reducer = null
        group_by_fields      = []
        per_series_aligner   = "ALIGN_SUM"
      }

      trigger {
        count   = 1
        percent = 0
      }
    }
  }
  documentation {
    content   = "### insert coupon usage execution error\n\n#### Summary\n\nScheduled Queryが失敗しました。原因を調査してください。\n\n#### Additional resource information\n\nhttps://console.cloud.google.com/bigquery/scheduled-queries/locations/us/configs/${local.icu_tc_id}/runs?project=$${resource.project}"
    mime_type = "text/markdown"
    subject   = null
  }
}
