enum Status {
  sleep,
  initial,
  loading,
  loaded,
  updating,
  updated,
  error,
}

enum ProductMode {
  lastestProds,
  bestSellerProds,
  offerProds,
  other,
}

enum ProductSort {
  notDetermined,
  lh,
  hl,
}

enum PaymentType {
  wallet,
  stripe,
  paymob,
  paypal,
  googlePay,
  applePay,
}