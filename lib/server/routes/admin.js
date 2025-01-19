const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const Admin = require("../models/admin");
const { ShopInfo } = require("../models/shopInfo");
const { OrderSettings } = require('../models/orderSettings');

adminRouter.post("/api/admin/add-shop-info", admin, async (req, res) => {
  try {
    console.log("Received shop data:", JSON.stringify(req.body, null, 2));
    const {
      shopName,
      number,
      address,
      shopCode,
      categories,
      delPrice,
      coupon,
      offerImages,
      offerDes,
      Offertime,
      socialLinks,
      charges,
      time
    } = req.body;

    function validateOfferDes(offerDes) {
      // Check if offerDes is a valid object
      if (typeof offerDes !== 'object' || offerDes === null) return false;
    
      // Check for descriptions array
      const descriptions = offerDes.descriptions;
      if (!Array.isArray(descriptions)) return false;
    
      // Validate each description
      return descriptions.every(
        (offer) =>
          typeof offer === "object" &&
          typeof offer.title === "string" &&
          offer.title.length <= 40 &&
          typeof offer.description === "string" &&
          offer.description.length <= 40 &&
          typeof offer.icon === "string"
      );
    }
    
    // In the route handler
    if (offerDes && !validateOfferDes(offerDes)) {
      console.log("Invalid offerDes format:", offerDes);
      return res.status(400).json({ msg: "Invalid offerDes format" });
    }


    // Validate the incoming data
    if (
      !shopName ||
      !number ||
      !address || 
      !time ||
      !shopCode ||
      !Array.isArray(categories) ||
      typeof delPrice !== "number" ||
      !charges
    ) {
      console.log("Invalid shop information:", {
        shopName,
        number,
        address,
        time,
        shopCode,
        categories,
        delPrice,
        charges,
      });
      return res.status(400).json({ msg: "Invalid shop information" });
    }

    // Validate charges structure
    if (
      typeof charges !== "object" ||
      typeof charges.isEnabled !== "boolean" ||
      (charges.isEnabled && typeof charges.charges !== "string")
    ) {
      console.log("Invalid charges format:", charges);
      return res.status(400).json({ msg: "Invalid charges format" });
    }

    const transformedCharges = {
      isDeliveryChargesEnabled: charges.isEnabled,
      deliveryCharges: parseFloat(charges.charges),
      startDate: charges.schedule?.startDate,
      endDate: charges.schedule?.endDate,
      startTime: charges.schedule?.startTime,
      endTime: charges.schedule?.endTime,
    };

    // Find the admin user using the authenticated admin ID
    let adminUser = await Admin.findById(req.admin);
    if (!adminUser) {
      console.log("Admin user not found for ID:", req.admin);
      return res.status(404).json({ msg: "Admin user not found" });
    }

    console.log("Found admin user:", adminUser);

    // Create the new shop info object
    const newShopInfo = {
      shopName,
      number,
      address,
      shopCode,
      time,
      categories,
      delPrice,
      coupon,
      offerImages,
      offerDes: offerDes || { descriptions: [], offerToggle: false },
      Offertime,
      socialLinks,
      charges: transformedCharges,
      lastUpdated: new Date(), // Add lastUpdated timestamp
    };

    console.log("Saving offerDes to database:", offerDes);
    console.log("Saving offerDes to database:", coupon);

    // Instead of finding index and updating, directly set the shopDetails array
    // This will replace all existing shop details with the new one
    adminUser.shopDetails = [newShopInfo];

    // Save the admin user with updated shopDetails
    await adminUser.save();
    console.log("Updated admin user:", adminUser);
    // Add these inside your route handler
    console.log("--------------------------");
    console.log("Received charges object:", charges);
    console.log("charges.isEnabled type:", typeof charges.isEnabled);
    console.log("Received coupon object:", JSON.stringify(coupon, null, 2));
    console.log("charges.charges type:", typeof charges.charges);
    return res.status(200).json({ success: true, shopInfo: newShopInfo });
  } catch (e) {
    console.error("Error in add-shop-info:", e);
    res.status(500).json({ error: e.message });
  }
});

// Route to fetch the latest shop info for a specific shop code for hive
adminRouter.get(
  "/api/admin/fetch-latest-shop-info",
  admin,
  async (req, res) => {
    try {
      const adminUser = await Admin.findById(req.admin);
      if (!adminUser) {
        console.log("Admin user not found for ID:", req.admin);
        return res.status(404).json({ msg: "Admin user not found" });
      }

      // Assuming you want to fetch the most recently updated shop info
      if (adminUser.shopDetails.length === 0) {
        return res.status(404).json({ msg: "No shop information found" });
      }

      // Sort shops by update time (if stored) and return the latest one
      const latestShopInfo = adminUser.shopDetails.reduce((latest, current) => {
        const latestTime = new Date(latest.Offertime || 0);
        const currentTime = new Date(current.Offertime || 0);
        return currentTime > latestTime ? current : latest;
      });

      console.log("Sending latest shop info:", latestShopInfo);
      return res.status(200).json(latestShopInfo);
    } catch (e) {
      console.error("Error fetching latest shop info:", e);
      return res.status(500).json({ error: e.message });
    }
  }
);

//// fetching shop info for storing in the shop info provider
adminRouter.get("/api/admin/fetch-shop-info", admin, async (req, res) => {
  try {
    // Fetch admin user from the database with populated shop details
    const adminUser = await Admin.findById(req.admin).populate("shopDetails");

    if (!adminUser) {
      console.log("Admin user not found for ID:", req.admin);
      return res.status(404).json({ msg: "Admin user not found" });
    }

    // Check if shopDetails exists
    if (!adminUser.shopDetails || adminUser.shopDetails.length === 0) {
      console.log("No shop details found for admin:", req.admin);
      return res.status(404).json({ msg: "No shop details found" });
    }

    // Return all shopDetails
    console.log("Returning shop details:", adminUser.shopDetails);
    return res.status(200).json(adminUser.shopDetails);
  } catch (e) {
    console.error("Error fetching shop details:", e);
    return res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/api/admin/add-product-info", admin, async (req, res) => {
  try {
    console.log("Received product data:", req.body);
    const { product } = req.body;

    if (
      !product ||
      !product.name ||
      !product.basePrice ||
      !Array.isArray(product.images)
    ) {
      return res.status(400).json({ msg: "Invalid product information" });
    }

    let adminUser = await Admin.findById(req.admin);
    if (!adminUser) {
      return res.status(404).json({ msg: "Admin user not found" });
    }

    // For new products, we don't check for existing _id
    adminUser.productsInfo.push({ product });
    await adminUser.save();

    return res
      .status(200)
      .json({ success: true, productsInfo: adminUser.productsInfo });
  } catch (e) {
    console.error("Error in add-product-info:", e);
    res.status(500).json({ error: e.message });
  }
});

// edit productinfo
adminRouter.put("/api/admin/edit-product-info", admin, async (req, res) => {
  try {
    console.log("Received product data for editing:", req.body);
    const { product } = req.body;

    if (
      !product ||
      !product._id ||
      !product.name ||
      !product.basePrice 
      // !Array.isArray(product.images)
    ) {
      return res.status(400).json({ msg: "Invalid product information" });
    }

    let adminUser = await Admin.findById(req.admin);
    if (!adminUser) {
      return res.status(404).json({ msg: "Admin user not found" });
    }

    // Find the product by its _id
    const productIndex = adminUser.productsInfo.findIndex(
      (p) => p.product._id.toString() === product._id
    );

    if (productIndex === -1) {
      return res.status(404).json({ msg: "Product not found" });
    }

    // Update product info
    adminUser.productsInfo[productIndex].product = product;

    await adminUser.save();

    return res
      .status(200)
      .json({ success: true, productsInfo: adminUser.productsInfo });
  } catch (e) {
    console.error("Error in edit-product-info:", e);
    res.status(500).json({ error: e.message });
  }
});



/// delete product from the shop
adminRouter.post(
  "/admin/delete-productinfo-product",
  admin,
  async (req, res) => {
    try {
      const { userId, productId } = req.body;

      // Find the user
      let user = await Admin.findById(userId);
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      // Remove the product from the user's productsInfo array
      user.productsInfo = user.productsInfo.filter(
        (item) => item.product._id.toString() !== productId
      );
      await user.save();

      res.json({ message: "Product removed from productsInfo successfully" });
    } catch (e) {
      console.error(e.message); // Log the error for debugging
      res.status(500).json({ error: e.message });
    }
  }
);


adminRouter.get("/admin/user-products/:shopCode", async (req, res) => {
  try {
    const { shopCode } = req.params;
    const { subCategory, category } = req.query;

    // Log the request details to debug
    console.log("ShopCode:", shopCode);
    console.log("SubCategory:", subCategory);
    console.log("Category:", category);

    // Find the admin with the matching shopCode
    const admin = await Admin.findOne({ shopCode: shopCode });
    console.log("Category:", admin);

    if (!admin) {
      console.log("Shop not found");
      return res.status(404).json({ message: "Shop not found" });
    }

    // Check if subCategory and category are provided
    if (!subCategory || !category) {
      console.log("SubCategory or Category is missing in the request");
      return res.status(400).json({ message: "Subcategory and Category are required" });
    }

    // Filter the products from admin's productsInfo by subCategory and category
    const filteredProducts = admin.productsInfo
      .filter((info) => 
        info.product.subCategory === subCategory && 
        info.product.category === category
      )
      .map((info) => info.product);

    if (filteredProducts.length === 0) {
      console.log("No products found for the subcategory and category:", subCategory, category);
      return res.status(404).json({
        message: "No products found for this subcategory and category"
      });
    }

    res.json(filteredProducts);
  } catch (e) {
    console.error("Server Error:", e.message);
    res.status(500).json({ error: e.message });
  }
});

//// orders settings
adminRouter.post("/api/admin/update-order-settings", admin, async (req, res) => {
  try {
    const { orderSettings } = req.body;

    console.log('Received Order Settings:', orderSettings);

    // Find the admin user
    let adminUser = await Admin.findById(req.admin);

    if (!adminUser) {
      return res.status(404).json({ msg: "Admin user not found" });
    }

    // Ensure shopDetails exists and is an array
    if (!adminUser.shopDetails || adminUser.shopDetails.length === 0) {
      adminUser.shopDetails = [{}];
    }

    // Get the first (or only) shop details
    let shopDetails = adminUser.shopDetails[0];

    // Explicitly map the incoming settings
    const updatedOrderSettings = {
      isOrderAcceptanceEnabled: orderSettings.orderAcceptanceEnabled,
      isNotificationEnabled: orderSettings.notificationsEnabled,
      isAutoAcceptEnabled: orderSettings.autoAcceptEnabled,
      isOrderAcceptEnabled: orderSettings.orderAcceptEnabled,
      isOrderConfirmationEnabled: orderSettings.orderConfirmationEnabled,
      isWhatsAppUpdatesEnabled: orderSettings.whatsAppUpdatesEnabled,
      isOrderCancellationAllowed: orderSettings.orderCancellationAllowed,
      selectedDeliveryMode: orderSettings.deliveryMode,
      selectedPaymentType: orderSettings.paymentType,
      cancellationPolicy: orderSettings.cancellationPolicy,
      lastUpdated: new Date()
    };

    // Update only the orderSettings field
    const result = await Admin.findOneAndUpdate(
      { _id: req.admin, 'shopDetails._id': shopDetails._id },
      {
        $set: {
          'shopDetails.$.orderSettings': updatedOrderSettings
        }
      },
      { 
        new: true,  // Return the modified document
        runValidators: true  // Run model validators
      }
    );

    if (!result) {
      return res.status(404).json({ msg: "Could not update order settings" });
    }

    return res.status(200).json({
      success: true,
      orderSettings: updatedOrderSettings
    });
  } catch (e) {
    console.error("Error in update-order-settings:", e);
    res.status(500).json({ 
      error: e.message,
      details: e.toString()
    });
  }
});




module.exports = adminRouter;
