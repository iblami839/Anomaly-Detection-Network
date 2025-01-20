;; Observation Data Contract

(define-data-var observation-counter uint u0)

(define-map observations uint {
    universe-id: uint,
    timestamp: uint,
    data: (string-utf8 1000),
    observer: principal
})

(define-public (record-observation (universe-id uint) (data (string-utf8 1000)))
    (let
        ((new-id (+ (var-get observation-counter) u1)))
        (map-set observations new-id
            {
                universe-id: universe-id,
                timestamp: block-height,
                data: data,
                observer: tx-sender
            }
        )
        (var-set observation-counter new-id)
        (ok new-id)
    )
)

(define-read-only (get-observation (id uint))
    (map-get? observations id)
)

(define-read-only (get-observation-count)
    (var-get observation-counter)
)

