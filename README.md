# farstore🌾 
### Bridging the Gap Between Farmers and Consumers

A revolutionary platform connecting farmers directly with consumers, eliminating middlemen and delivering farm-fresh produce at competitive prices while significantly reducing delivery times.

[![Tech Stack](https://img.shields.io/badge/Tech%20Stack-Flutter%20%7C%20MongoDB%20%7C%20Express.js%20%7C%20Node.js-green)](#tech-stack)
[![Farmer Commitment](https://img.shields.io/badge/Farmer%20Commitment-61%25-success)](#impact)
[![User Retention](https://img.shields.io/badge/User%20Retention-74%25-success)](#impact)

## Impact 📈

- **15% Lower Prices** compared to traditional market rates
- **80% Reduction** in delivery times
- **61% Commitment Rate** from partner farmers
- **74% User Retention Rate**

## Features

### For Farmers 👨‍🌾
- **Direct Market Access**: Connect directly with consumers
- **Inventory Management**: Track and manage produce inventory
- **Order Management**: Efficient order processing system
- **Price Control**: Set competitive prices for products
- **Delivery Management**: Optimize delivery routes
- **Map Navigation**: Efficient delivery route planning
- **Inventory Oversight**: Monitor farm-wide inventory
- **Analytics Dashboard**: Track platform performance
- **User Management**: Handle both farmer and consumer accounts
- **Quality Control**: Maintain product standards
- and many more

## Screenshots
To explore the app's user interface, you can view the sample images provided [here on Google Drive](https://drive.google.com/drive/folders/12K6IJ-e4jf160u6gRkjM4H_GlgoNCBxM?usp=sharing).


⚠️ Note: Not all UI images are included directly in this repository due to space constraints. Check the Google Drive link for the complete set of screenshots.

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Node.js, Express.js
- **Database**: MongoDB
- **Design**: Figma
- **Infrastructure**: Cloud Services

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/shivprasadrahulwad/farcon.git
```

2. Install dependencies
```bash
cd farcon
npm install
```

3. Configure environment variables
```bash
cp .env.example .env
```

4. Start the development server
```bash
npm run dev
```

## Environment Setup

### Prerequisites
- Node.js (v14 or higher)
- MongoDB
- Flutter SDK
- Android Studio / Xcode (for mobile development)

## API Documentation

### Authentication Endpoints
```
POST /api/auth/farmer/register
POST /api/auth/user/register
POST /api/auth/login
```

### Product Endpoints
```
GET /api/products
POST /api/products/create
PUT /api/products/:id
DELETE /api/products/:id
```

### Order Endpoints
```
GET /api/orders
POST /api/orders/create
PUT /api/orders/:id/status
```

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Future Roadmap 🚀

- [ ] Implementation of AI-based demand prediction
- [ ] Integration with weather APIs for farming insights
- [ ] Expansion to more geographical regions
- [ ] Addition of organic certification tracking
- [ ] Implementation of blockchain for supply chain transparency

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact

Project Link: [https://github.com/shivprasadrahulwad/farcon](https://github.com/shivprasadrahulwad/farcon)

---

<div align="center">
Made with ❤️ by Shivprasad Rahulwad
</div>
