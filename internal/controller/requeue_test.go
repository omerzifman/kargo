package controller

import (
    "testing"
    "time"

    "github.com/stretchr/testify/require"
)

func TestResultWithRequeue(t *testing.T) {
    t.Run("uses custom interval when positive", func(t *testing.T) {
        interval := 30 * time.Second
        def := 5 * time.Minute
        res := ResultWithRequeue(interval, def)
        require.Equal(t, interval, res.RequeueAfter)
    })

    t.Run("falls back to default when zero", func(t *testing.T) {
        interval := time.Duration(0)
        def := 2 * time.Minute
        res := ResultWithRequeue(interval, def)
        require.Equal(t, def, res.RequeueAfter)
    })

    t.Run("falls back to default when negative", func(t *testing.T) {
        interval := -1 * time.Second
        def := 90 * time.Second
        res := ResultWithRequeue(interval, def)
        require.Equal(t, def, res.RequeueAfter)
    })
}
