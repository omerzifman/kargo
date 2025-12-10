package controller

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestResultWithRequeue(t *testing.T) {
	t.Run("uses custom interval when positive", func(t *testing.T) {
		interval := 30 * time.Second
		res := ResultWithRequeue(interval)
		require.Equal(t, interval, res.RequeueAfter)
	})

	t.Run("falls back to default when zero", func(t *testing.T) {
		interval := time.Duration(0)
		res := ResultWithRequeue(interval)
		require.Equal(t, DefaultReconciliationInterval, res.RequeueAfter)
	})

	t.Run("falls back to default when negative", func(t *testing.T) {
		interval := -1 * time.Second
		res := ResultWithRequeue(interval)
		require.Equal(t, DefaultReconciliationInterval, res.RequeueAfter)
	})
}
