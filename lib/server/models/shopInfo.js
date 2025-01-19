const mongoose = require("mongoose");
const { categorySchema } = require("./category");
const { couponSchema } = require("./coupon");
const { offerDescriptionSchema } = require("./offerDes");
const { chargesSchema } = require("./charges");
const { orderSettingsSchema } = require("./orderSettings");
const ratingSchema = require("./ratings");

const shopInfoSchema = mongoose.Schema({
  shopName: {
    required: false,
    type: String,
  },
  number: {
    required: false,
    type: String,
  },
  address: {
    required: false,
    type: String,
    default: "",
  },

  time:{
    required: false,
    type: String,
    default: "7AM - 10PM",
  },

  shopCode: {
    required: false,
    type: String,
    // unique: true,
  },

  categories: [categorySchema],

  delPrice: {
    type: Number,
    required: false,
    default: 0,
  },

  coupon: {
    type: {
      coupons: {
        type: [couponSchema], // Array of coupon objects
        validate: {
          validator: function (coupons) {
            return coupons.length <= 6;
          },
          message: 'A shop can have a maximum of 6 coupons',
        },
      },
      couponToggle: {
        type: Boolean, // A boolean value to enable/disable coupons
        default: false,
      },
    },
  },  

  offerImages: {
    type: {
      images: {
        type: [String], 
        validate: {
          validator: function (images) {
            return images.length <= 10; 
          },
          message: 'A shop can have a maximum of 10 offer images',
        },
      },
      offerImagesToggle: {
        type: Boolean, 
        default: false, 
      },
    },
  },


  offerDes: {
    type: {
      descriptions: {
        type: [offerDescriptionSchema], // Array of offer description objects
        validate: {
          validator: function(descriptions) {
            return descriptions.length <= 5;
          },
          message: 'A shop can have a maximum of 6 offer descriptions',
        },
      },
      offerToggle: {
        type: Boolean, // A boolean value to enable/disable offers
        default: false, // Default is disabled
      },
    },
  },
  
  
  Offertime: {
    type: Date,
    required: false,
    default: new Date('2024-10-13'),
  },

  socialLinks: {
    type: [String], 
    required: false,
    default: [], 
  },

  lastUpdated: {
    type: Date,
    required: true,
    default: Date.now, 
  },

  charges: {
    type: chargesSchema,
    required: false,
    default: () => ({
      isDeliveryChargesEnabled: false
    })
  },

  orderSettings: {
    type: orderSettingsSchema, 
    required: false,
  },

  ratings: [ratingSchema]

});

const ShopInfo = mongoose.model("ShopInfo", shopInfoSchema);
module.exports = { ShopInfo, shopInfoSchema ,chargesSchema};
