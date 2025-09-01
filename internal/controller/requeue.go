package controller

import (
	"time"

	ctrl "sigs.k8s.io/controller-runtime"
)

// ResultWithRequeue returns a ctrl.Result that requeues after the provided
// interval. If interval is zero or negative, defaultInterval is used instead.
func ResultWithRequeue(interval, defaultInterval time.Duration) ctrl.Result {
	if interval <= 0 {
		interval = defaultInterval
	}
	return ctrl.Result{RequeueAfter: interval}
}
