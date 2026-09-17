enum NotificationType {
  // PRODUCER types
  orderPlaced,
  orderCancelled,
  lowStock,
  reviewReceived,

  // BUYER types
  orderConfirmed,
  orderShipped,
  orderDelivered,
  promo,

  // DELIVERY types
  newJob,
  jobCancelled,
  earningCredited,
  ratingReceived,

  // General types
  system,
}