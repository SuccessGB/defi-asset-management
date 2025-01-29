;; DeFi Asset Management Platform

;; Define the contract admin
(define-data-var contract-admin principal tx-sender)

;; Define the token structure
(define-map tokens
  { token-id: uint }
  {
    token-name: (string-ascii 64),
    token-category: (string-ascii 32),
    max-supply: uint,
    token-price: uint
  }
)

;; Define balances structure
(define-map balances
  { holder: principal, token-id: uint }
  { amount: uint }
)

;; Define allowance structure
(define-map allowances
  { holder: principal, authorized: principal, token-id: uint }
  { allowed-amount: uint }
)

;; Define error constants
(define-constant err-not-authorized (err u100))
(define-constant err-token-exists (err u101))
(define-constant err-token-not-found (err u102))
(define-constant err-insufficient-funds (err u103))
(define-constant err-invalid-token-name (err u104))
(define-constant err-invalid-category (err u105))
(define-constant err-invalid-max-supply (err u106))
(define-constant err-invalid-token-price (err u107))
(define-constant err-invalid-recipient (err u108))
(define-constant err-invalid-transfer-amount (err u109))
(define-constant err-insufficient-allowance (err u110))
(define-constant err-invalid-authorized-addr (err u111))

;; Counter for token IDs
(define-data-var token-counter uint u0)

;; Function to create a new token
(define-public (mint-token (token-name (string-ascii 64)) (token-category (string-ascii 32)) (max-supply uint) (token-price uint))
  (let
    (
      (token-id (+ (var-get token-counter) u1))
    )
    (asserts! (is-eq tx-sender (var-get contract-admin)) err-not-authorized)
    (asserts! (is-none (map-get? tokens { token-id: token-id })) err-token-exists)
    ;; Input validation
    (asserts! (> (len token-name) u0) err-invalid-token-name)
    (asserts! (> (len token-category) u0) err-invalid-category)
    (asserts! (> max-supply u0) err-invalid-max-supply)
    (asserts! (> token-price u0) err-invalid-token-price)
    (map-set tokens
      { token-id: token-id }
      { token-name: token-name, token-category: token-category, max-supply: max-supply, token-price: token-price }
    )
    (map-set balances
      { holder: (var-get contract-admin), token-id: token-id }
      { amount: max-supply }
    )
    (var-set token-counter token-id)
    (ok token-id)
  )
)

;; Function to validate token-id
(define-read-only (is-valid-token (token-id uint))
  (is-some (map-get? tokens { token-id: token-id }))
)

;; Function to authorize spending
(define-public (authorize-spending (authorized principal) (token-id uint) (allowed-amount uint))
  (let
    (
      (holder tx-sender)
    )
    (asserts! (is-valid-token token-id) err-token-not-found)
    (asserts! (not (is-eq authorized holder)) err-invalid-authorized-addr)
    (asserts! (>= allowed-amount u0) err-invalid-transfer-amount)
    (map-set allowances
      { holder: holder, authorized: authorized, token-id: token-id }
      { allowed-amount: allowed-amount }
    )
    (ok true)
  )
)

;; Function to get authorized amount
(define-read-only (get-authorized-amount (holder principal) (authorized principal) (token-id uint))
  (default-to { allowed-amount: u0 }
    (map-get? allowances { holder: holder, authorized: authorized, token-id: token-id })
  )
)

;; Function to transfer tokens
(define-public (transfer (recipient principal) (token-id uint) (transfer-amount uint))
  (let
    (
      (sender tx-sender)
    )
    (asserts! (is-valid-token token-id) err-token-not-found)
    (asserts! (not (is-eq recipient sender)) err-invalid-recipient)
    (asserts! (> transfer-amount u0) err-invalid-transfer-amount)
    (process-transfer sender recipient token-id transfer-amount)
  )
)

