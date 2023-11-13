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
  cashOnDelivery,
  wallet,
  stripe,
  paymob,
  paypal,
}