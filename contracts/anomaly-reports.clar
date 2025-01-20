;; Anomaly Reports Contract

(define-data-var anomaly-counter uint u0)

(define-map anomalies uint {
    universe-id: uint,
    observation-id: uint,
    description: (string-utf8 1000),
    severity: uint,
    reporter: principal,
    status: (string-ascii 20)
})

(define-public (report-anomaly (universe-id uint) (observation-id uint) (description (string-utf8 1000)) (severity uint))
    (let
        ((new-id (+ (var-get anomaly-counter) u1)))
        (map-set anomalies new-id
            {
                universe-id: universe-id,
                observation-id: observation-id,
                description: description,
                severity: severity,
                reporter: tx-sender,
                status: "open"
            }
        )
        (var-set anomaly-counter new-id)
        (ok new-id)
    )
)

(define-public (update-anomaly-status (id uint) (new-status (string-ascii 20)))
    (let
        ((anomaly (unwrap! (map-get? anomalies id) (err u404))))
        (ok (map-set anomalies id
            (merge anomaly { status: new-status })))
    )
)

(define-read-only (get-anomaly (id uint))
    (map-get? anomalies id)
)

(define-read-only (get-anomaly-count)
    (var-get anomaly-counter)
)

