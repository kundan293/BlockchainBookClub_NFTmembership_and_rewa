;; Blockchain Book Club – NFT Membership and Rewards
;; Minimal version with NFT minting and reward function

(define-non-fungible-token book-club-pass uint)

(define-fungible-token reader-reward)

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-already-has-pass (err u101))
(define-constant err-invalid-amount (err u102))

(define-data-var total-members uint u0)
(define-data-var total-rewarded uint u0)

;; Mapping of addresses who already own NFT pass
(define-map has-pass principal bool)

;; Function 1: Mint Book Club NFT Membership
(define-public (mint-membership)
  (begin
    (asserts! (is-none (nft-get-owner? book-club-pass (to-uint! (var-get total-members)))) err-already-has-pass)
    (nft-mint? book-club-pass (var-get total-members) tx-sender)
    (map-set has-pass tx-sender true)
    (var-set total-members (+ (var-get total-members) u1))
    (ok true)))

;; Function 2: Reward Reader With Tokens
(define-public (reward-reader (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (try! (ft-mint? reader-reward amount recipient))
    (var-set total-rewarded (+ (var-get total-rewarded) amount))
    (ok true)))
