package controller

import (
	"time"

	ctrl "sigs.k8s.io/controller-runtime"
)

const (
	// DefaultReconciliationInterval is the default interval for requeuing
	// reconciliation when no interval is configured.
	DefaultReconciliationInterval = 5 * time.Minute
)

// ResultWithRequeue returns a ctrl.Result that requeues after the provided
// interval. If interval is zero or negative, DefaultReconciliationInterval is used instead.
func ResultWithRequeue(interval time.Duration) ctrl.Result {
	if interval <= 0 {
		interval = DefaultReconciliationInterval
	}
	return ctrl.Result{RequeueAfter: interval}
}
