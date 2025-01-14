const mongoose = require("mongoose");

const orderSettingsSchema = mongoose.Schema({
  isOrderAcceptanceEnabled: {
    type: Boolean,
    required: false,
    default: true,
  },
  isNotificationEnabled: {
    type: Boolean,
    required: false,
    default: false,
  },
  isAutoAcceptEnabled: {
    type: Boolean,
    required: false,
    default: false,
  },
  isOrderAcceptEnabled: {
    type: Boolean,
    required: false,
    default: false,
  },
  isOrderConfirmationEnabled: {
    type: Boolean,
    required: false,
    default: false,
  },
  isWhatsAppUpdatesEnabled: {
    type: Boolean,
    required: false,
    default: false,
  },
  isOrderCancellationAllowed: {
    type: Boolean,
    required: false,
    default: false,
  },
  selectedDeliveryMode: {
    type: String,
    required: false,
    default: "Standard",
  },
  selectedPaymentType: {
    type: String,
    required: false,
    default: "Cash (COD)",
  },
  cancellationPolicy: {
    type: String,
    required: false,
  },
  lastUpdated: {
    type: Date,
    required: true,
    default: Date.now,
  },
});

const OrderSettings = mongoose.model("OrderSettings", orderSettingsSchema);

module.exports = { OrderSettings, orderSettingsSchema };
