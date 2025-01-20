;; Universe Parameters Contract

(define-data-var parameter-counter uint u0)

(define-map universe-parameters uint {
    name: (string-ascii 50),
    value: (string-utf8 100),
    description: (string-utf8 500)
})

(define-public (add-parameter (name (string-ascii 50)) (value (string-utf8 100)) (description (string-utf8 500)))
    (let
        ((new-id (+ (var-get parameter-counter) u1)))
        (map-set universe-parameters new-id
            {
                name: name,
                value: value,
                description: description
            }
        )
        (var-set parameter-counter new-id)
        (ok new-id)
    )
)

(define-public (update-parameter (id uint) (new-value (string-utf8 100)))
    (let
        ((parameter (unwrap! (map-get? universe-parameters id) (err u404))))
        (ok (map-set universe-parameters id
            (merge parameter { value: new-value })))
    )
)

(define-read-only (get-parameter (id uint))
    (map-get? universe-parameters id)
)

(define-read-only (get-parameter-count)
    (var-get parameter-counter)
)

