# Style_SPhere
## 👥 Group number :6

## 👥 Team Members

| Name | ID | Contribution |
|------|----|--------------|
| Pollab Das | 242-115-305 | Frontend |
| Sami dashtidar | 242-115-337 | Database |
| Alok Talukder | 242-115-328 | Backend |
| Tinni Bonik | 242-115-115 | Debugger |


Project Structure
## 📂 Project Structure

```text
STYLESPHERE/
│
├── 1. 📁 api/                         # Backend API endpoints
│   │
│   ├── config.php                     # Database connection configuration
│   ├── login.php                      # User authentication
│   ├── register.php                   # User registration
│   ├── quick-login.php                # Email-based quick login
│   ├── forgot-password.php            # Password reset
│   │
│   ├── 01. Product APIs
│   │   ├── get-products.php           # Get all products
│   │   ├── get-product.php            # Get single product
│   │   ├── add-product.php             # Add product (Admin)
│   │   ├── update-product.php          # Update product (Admin)
│   │   ├── delete-product.php          # Delete product (Admin)
│   │   └── update-stock.php            # Update product stock (Admin)
│   │
│   ├── 02. Order APIs
│   │   ├── get-orders.php              # Get orders
│   │   ├── get-order.php               # Get single order
│   │   ├── create-order.php             # Create new order
│   │   └── update-order.php             # Update order (Admin)
│   │
│   ├── 03. User APIs
│   │   ├── get-users.php                # Get users (Admin)
│   │   ├── get-user.php                 # Get single user
│   │   ├── update-user.php              # Update user profile
│   │   ├── delete-user.php              # Delete user (Admin)
│   │   ├── get-user-tier.php            # Get user loyalty tier
│   │   └── update-user-tier.php         # Update user tier
│   │
│   ├── 04. Blog APIs
│   │   ├── get-blogs.php                # Get blog posts
│   │   ├── get-blog.php                 # Get single blog post
│   │   ├── add-blog.php                 # Add blog (Admin)
│   │   ├── update-blog.php              # Update blog (Admin)
│   │   ├── delete-blog.php              # Delete blog (Admin)
│   │   ├── submit-blog.php              # Submit blog (User)
│   │   ├── approve-blog.php             # Approve blog submission (Admin)
│   │   └── get-blog-submissions.php     # Get submitted blogs
│   │
│   ├── 05. Review & Coupon APIs
│   │   ├── submit-review.php             # Submit product review
│   │   ├── get-reviews.php               # Get product reviews
│   │   ├── coupons.php                   # Coupon CRUD and application
│   │   └── return-request.php            # Return/exchange requests
│   │
│   ├── 06. Homepage APIs
│   │   ├── get-homepage.php              # Get homepage content
│   │   ├── update-homepage.php           # Update homepage (Admin)
│   │   ├── update-carousel.php           # Manage carousel (Admin)
│   │   └── update-feature.php            # Manage features (Admin)
│   │
│   └── 07. Utility APIs
│       ├── upload-image.php               # Image upload handler
│       ├── reset-database.php             # Reset database (Admin)
│       ├── generate-hash.php              # Password hash generator
│       ├── check-uploads.php              # Check upload directory
│       ├── compress-image.php             # Image compression
│       ├── fix-images.php                 # Fix image paths
│       └── generate-reviews.php           # Generate sample reviews
│
├── 2. 📁 css/                           # Website stylesheets
│   └── style.css                        # Main stylesheet
│
├── 3. 📁 js/                            # Client-side JavaScript
│   ├── utils.js                          # Common utility functions
│   ├── navigation.js                     # Navigation rendering
│   ├── index.js                          # Homepage functionality
│   └── shop.js                           # Shop functionality
│
├── 4. 📁 uploads/                       # Uploaded media files
│   ├── Product Images
│   ├── Blog Images
│   └── Carousel Images
│
├── 5. 🌐 User Pages
│   ├── index.html                        # Homepage
│   ├── shop.html                         # Product listing
│   ├── products.html                     # Product details
│   ├── cart.html                         # Shopping cart
│   ├── payment.html                      # Checkout and payment
│   ├── wishlist.html                     # Wishlist
│   ├── compare.html                      # Product comparison
│   ├── order-tracking.html               # Order tracking
│   ├── dashboard.html                    # User dashboard
│   ├── login.html                        # Login page
│   ├── about.html                        # About page
│   ├── contact.html                      # Contact page
│   ├── blog.html                         # Blog listing
│   ├── blog-post.html                    # Individual blog post
│   └── blog-submit.html                  # Blog submission
│
├── 6. 🔐 Admin Pages
│   ├── admin-dashboard.html              # Admin dashboard
│   ├── admin-products.html               # Product management
│   ├── admin-orders.html                 # Order management
│   ├── admin-users.html                  # User management
│   ├── admin-blog.html                   # Blog management
│   ├── admin-coupons.html                # Coupon management
│   ├── admin-returns.html                # Return management
│   ├── admin-homepage.html               # Homepage management
│   └── admin-settings.html               # Admin settings
│
├── 7. ⚙️ Configuration & Database
│   ├── manifest.json                     # PWA manifest
│   ├── setup.sql                         # Database schema and seed data
│   └── config.php                        # Database connection configuration
│
└── 8. 📖 Documentation
    └── README.md                         # Project documentation
```

### 📌 Structure Overview

|    No. | Directory / Section      | Purpose                                                                                                                             |
| -----: | ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| **01** | `api/`                   | Contains PHP backend APIs for authentication, products, orders, users, blogs, reviews, coupons, homepage management, and utilities. |
| **02** | `css/`                   | Contains the website's CSS styling.                                                                                                 |
| **03** | `js/`                    | Contains client-side JavaScript functionality and reusable utilities.                                                               |
| **04** | `uploads/`               | Stores uploaded product, blog, and carousel images.                                                                                 |
| **05** | User Pages               | Contains the customer-facing HTML pages for shopping and account management.                                                        |
| **06** | Admin Pages              | Contains the administrative interface for managing the StyleSphere platform.                                                        |
| **07** | Configuration & Database | Contains database setup, connection configuration, and PWA configuration.                                                           |
| **08** | Documentation            | Contains project documentation and README information.                                                                              |

### 🔄 Application Architecture

```text
                    ┌──────────────────────┐
                    │      STYLESPHERE     │
                    └──────────┬───────────┘
                               │
              ┌────────────────┴────────────────┐
              │                                 │
       ┌──────▼──────┐                   ┌──────▼──────┐
       │ User Pages  │                   │ Admin Pages │
       └──────┬──────┘                   └──────┬──────┘
              │                                 │
              └────────────────┬────────────────┘
                               │
                       ┌───────▼───────┐
                       │   PHP APIs    │
                       │    /api/      │
                       └───────┬───────┘
                               │
                 ┌─────────────▼─────────────┐
                 │          MySQL             │
                 │        setup.sql           │
                 └───────────────────────────┘
```

> **Note:** The numbered sections are documentation categories for readability. They do not imply that the files must physically be moved into numbered folders.
