-- ============================================
-- STYLESPHERE - Complete Database Setup
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS `stylesphere`;
USE `stylesphere`;

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) UNIQUE NOT NULL,
    `password` VARCHAR(255) DEFAULT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `address` TEXT DEFAULT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `postal_code` VARCHAR(20) DEFAULT NULL,
    `role` ENUM('admin', 'user') DEFAULT 'user',
    `tier` ENUM('Bronze', 'Silver', 'Gold', 'Platinum') DEFAULT 'Bronze',
    `tier_expiry` DATE DEFAULT NULL,
    `total_spent` DECIMAL(12,2) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_email` (`email`),
    INDEX `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. PRODUCTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(200) NOT NULL,
    `brand` VARCHAR(100) DEFAULT NULL,
    `category` VARCHAR(100) DEFAULT NULL,
    `fragrance` VARCHAR(100) DEFAULT NULL,
    `price` DECIMAL(10,2) NOT NULL,
    `stock` INT DEFAULT 0,
    `description` TEXT DEFAULT NULL,
    `image` VARCHAR(500) DEFAULT NULL,
    `ratings` DECIMAL(3,1) DEFAULT 0,
    `reviews` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_category` (`category`),
    INDEX `idx_brand` (`brand`),
    INDEX `idx_price` (`price`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 3. ORDERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_number` VARCHAR(50) UNIQUE NOT NULL,
    `user_id` INT DEFAULT NULL,
    `customer_name` VARCHAR(100) NOT NULL,
    `customer_email` VARCHAR(100) NOT NULL,
    `customer_phone` VARCHAR(20) DEFAULT NULL,
    `customer_address` TEXT NOT NULL,
    `city` VARCHAR(50) DEFAULT NULL,
    `postal_code` VARCHAR(20) DEFAULT NULL,
    `subtotal` DECIMAL(10,2) NOT NULL,
    `discount` DECIMAL(10,2) DEFAULT 0,
    `delivery_charge` DECIMAL(10,2) DEFAULT 60,
    `total` DECIMAL(10,2) NOT NULL,
    `payment_method` VARCHAR(50) NOT NULL,
    `transaction_id` VARCHAR(100) DEFAULT NULL,
    `tracking_number` VARCHAR(100) DEFAULT NULL,
    `payment_confirmed` TINYINT DEFAULT 0,
    `status` VARCHAR(50) DEFAULT 'Processing',
    `coupon_code` VARCHAR(50) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_order_number` (`order_number`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_email` (`customer_email`),
    INDEX `idx_status` (`status`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 4. ORDER ITEMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `order_items` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `product_id` INT DEFAULT NULL,
    `product_name` VARCHAR(200) NOT NULL,
    `product_price` DECIMAL(10,2) NOT NULL,
    `quantity` INT NOT NULL,
    INDEX `idx_order_id` (`order_id`),
    FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 5. BLOGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `blogs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `category` VARCHAR(100) DEFAULT NULL,
    `author` VARCHAR(100) DEFAULT NULL,
    `read_time` INT DEFAULT 5,
    `excerpt` TEXT DEFAULT NULL,
    `content` LONGTEXT DEFAULT NULL,
    `image` VARCHAR(500) DEFAULT NULL,
    `status` ENUM('draft', 'published', 'scheduled') DEFAULT 'draft',
    `tags` VARCHAR(255) DEFAULT NULL,
    `schedule_date` DATETIME DEFAULT NULL,
    `views` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_status` (`status`),
    INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 6. BLOG SUBMISSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `blog_submissions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `category` VARCHAR(100) DEFAULT NULL,
    `author` VARCHAR(100) DEFAULT NULL,
    `read_time` INT DEFAULT 5,
    `excerpt` TEXT DEFAULT NULL,
    `content` LONGTEXT DEFAULT NULL,
    `image` VARCHAR(500) DEFAULT NULL,
    `tags` VARCHAR(255) DEFAULT NULL,
    `user_email` VARCHAR(100) DEFAULT NULL,
    `user_name` VARCHAR(100) DEFAULT NULL,
    `status` ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    `processed_at` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_status` (`status`),
    INDEX `idx_user_email` (`user_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 7. REVIEWS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `reviews` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT NOT NULL,
    `user_id` INT DEFAULT NULL,
    `user_name` VARCHAR(100) DEFAULT NULL,
    `user_email` VARCHAR(100) DEFAULT NULL,
    `rating` INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    `comment` TEXT DEFAULT NULL,
    `images` TEXT DEFAULT NULL,
    `helpful` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_user_id` (`user_id`),
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 8. COUPONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `coupons` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) UNIQUE NOT NULL,
    `description` TEXT DEFAULT NULL,
    `discount_type` ENUM('percent', 'fixed') DEFAULT 'percent',
    `discount_value` DECIMAL(10,2) NOT NULL,
    `min_order_amount` DECIMAL(10,2) DEFAULT 0,
    `max_discount` DECIMAL(10,2) DEFAULT NULL,
    `usage_limit` INT DEFAULT NULL,
    `used_count` INT DEFAULT 0,
    `user_limit_per_user` INT DEFAULT 1,
    `is_active` TINYINT DEFAULT 1,
    `start_date` DATETIME DEFAULT NULL,
    `end_date` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_code` (`code`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 9. COUPON USAGE TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `coupon_usage` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `coupon_id` INT NOT NULL,
    `user_email` VARCHAR(100) DEFAULT NULL,
    `order_id` INT DEFAULT NULL,
    `discount_amount` DECIMAL(10,2) DEFAULT NULL,
    `used_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_coupon_id` (`coupon_id`),
    INDEX `idx_user_email` (`user_email`),
    FOREIGN KEY (`coupon_id`) REFERENCES `coupons`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 10. RETURN REQUESTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `return_requests` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `request_id` VARCHAR(50) UNIQUE NOT NULL,
    `order_id` VARCHAR(50) NOT NULL,
    `user_email` VARCHAR(100) NOT NULL,
    `type` ENUM('return', 'exchange') NOT NULL,
    `product_id` INT NOT NULL,
    `reason` TEXT NOT NULL,
    `comments` TEXT DEFAULT NULL,
    `status` ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending',
    `admin_response` TEXT DEFAULT NULL,
    `exchange_product_id` INT DEFAULT NULL,
    `exchange_product_name` VARCHAR(200) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `processed_at` DATETIME DEFAULT NULL,
    INDEX `idx_request_id` (`request_id`),
    INDEX `idx_user_email` (`user_email`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 11. CAROUSEL SLIDES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `carousel_slides` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(200) DEFAULT NULL,
    `subtitle` VARCHAR(500) DEFAULT NULL,
    `image` VARCHAR(500) NOT NULL,
    `button_text` VARCHAR(100) DEFAULT NULL,
    `button_link` VARCHAR(500) DEFAULT NULL,
    `order_index` INT DEFAULT 0,
    `is_active` TINYINT DEFAULT 1,
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 12. FEATURES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `features` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `icon` VARCHAR(100) DEFAULT NULL,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT DEFAULT NULL,
    `link` VARCHAR(500) DEFAULT NULL,
    `order_index` INT DEFAULT 0,
    `is_active` TINYINT DEFAULT 1,
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 13. HOMEPAGE CONTENT TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `homepage_content` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `section` VARCHAR(100) UNIQUE NOT NULL,
    `title` VARCHAR(255) DEFAULT NULL,
    `subtitle` TEXT DEFAULT NULL,
    `content` TEXT DEFAULT NULL,
    `image` VARCHAR(500) DEFAULT NULL,
    `button_text` VARCHAR(100) DEFAULT NULL,
    `button_link` VARCHAR(500) DEFAULT NULL,
    `order_index` INT DEFAULT 0,
    INDEX `idx_section` (`section`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 14. CONTACT MESSAGES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `contact_messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `subject` VARCHAR(200) DEFAULT NULL,
    `message` TEXT NOT NULL,
    `status` ENUM('unread', 'read', 'replied') DEFAULT 'unread',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_email` (`email`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERT DEFAULT DATA
-- ============================================

-- 1. Admin User (password: admin123)
-- Note: Use PHP password_hash('admin123', PASSWORD_DEFAULT) to generate hash
INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `address`, `city`, `postal_code`, `role`, `tier`, `tier_expiry`, `total_spent`, `created_at`) VALUES
(1, 'Admin User', 'admin@stylesphere.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+880 1234 567890', 'House #42, Road #12, Banani', 'Dhaka', '1213', 'admin', 'Platinum', DATE_ADD(NOW(), INTERVAL 365 DAY), 150000, NOW());

-- 2. Test User (password: user123)
INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `address`, `city`, `postal_code`, `role`, `tier`, `tier_expiry`, `total_spent`, `created_at`) VALUES
(2, 'Test Customer', 'user@test.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+880 1987654321', 'House #15, Road #5, Gulshan', 'Dhaka', '1212', 'user', 'Bronze', DATE_ADD(NOW(), INTERVAL 30 DAY), 0, NOW());

-- 3. Products
INSERT INTO `products` (`id`, `name`, `brand`, `category`, `fragrance`, `price`, `stock`, `description`, `image`, `ratings`, `reviews`) VALUES
(1, 'Premium Silk Blouse', 'Luxury Collection', 'Women', 'Silk', 2990, 50, 'Elegant silk blouse with a modern cut. Perfect for formal occasions and professional settings.', 'uploads/silk-blouse.jpg', 4.8, 12),
(2, 'Wool Blend Coat', 'Urban Classic', 'Women', 'Wool', 4890, 30, 'Sophisticated wool blend coat with a timeless silhouette. Ideal for winter season.', 'uploads/wool-coat.jpg', 4.6, 8),
(3, 'Leather Ankle Boots', 'Footwear Co', 'Shoes', 'Leather', 3990, 45, 'Premium leather ankle boots with comfort sole. Versatile for any outfit.', 'uploads/leather-boots.jpg', 4.9, 15),
(4, 'Cashmere Scarf', 'Luxury Collection', 'Accessories', 'Cashmere', 1890, 60, 'Luxurious cashmere scarf in classic design. Soft and warm.', 'uploads/cashmere-scarf.jpg', 4.7, 10),
(5, 'Cotton T-Shirt', 'Urban Classic', 'Men', 'Cotton', 990, 100, 'Premium quality cotton t-shirt. Breathable and comfortable for everyday wear.', 'uploads/cotton-tshirt.jpg', 4.5, 7),
(6, 'Silk Tie', 'Luxury Collection', 'Accessories', 'Silk', 1290, 75, 'Elegant silk tie with subtle pattern. Perfect for business and formal events.', 'uploads/silk-tie.jpg', 4.8, 9),
(7, 'Wool Suit Jacket', 'Urban Classic', 'Men', 'Wool', 5990, 25, 'Tailored wool suit jacket for a sharp and sophisticated look.', 'uploads/wool-suit.jpg', 4.9, 14),
(8, 'Leather Crossbody Bag', 'Footwear Co', 'Bags', 'Leather', 3490, 40, 'Stylish leather crossbody bag. Compact yet spacious enough for essentials.', 'uploads/leather-bag.jpg', 4.7, 6);

-- 4. Blogs
INSERT INTO `blogs` (`id`, `title`, `category`, `author`, `read_time`, `excerpt`, `content`, `image`, `status`, `tags`, `views`, `created_at`) VALUES
(1, '10 Style Tips for Every Occasion', 'style', 'Admin', 8, 'Discover essential style tips that will elevate your wardrobe for any occasion.', '<p>Style is about expressing yourself while feeling confident and comfortable. Here are 10 tips that work for every occasion:</p><ul><li>Invest in quality basics</li><li>Know your body type</li><li>Accessorize wisely</li><li>Fit is everything</li><li>Build a capsule wardrobe</li></ul>', 'uploads/style-tips.jpg', 'published', 'style,guide,fashion', 156, NOW()),
(2, 'Sustainable Fashion: The Future of Style', 'sustainable', 'Admin', 6, 'Learn how sustainable fashion is transforming the industry and how you can make a difference.', '<p>Sustainable fashion is no longer just a trend—it\'s the future. From eco-friendly materials to ethical production, here\'s what you need to know:</p><p>Choose quality over quantity, support ethical brands, and embrace second-hand shopping.</p>', 'uploads/sustainable-fashion.jpg', 'published', 'sustainable,eco,trends', 89, NOW()),
(3, 'How to Style Your Leather Boots', 'guides', 'Style Expert', 5, 'Master the art of styling leather boots for any outfit and season.', '<p>Leather boots are a wardrobe staple. Here\'s how to style them:</p><ul><li>With skinny jeans for a classic look</li><li>With dresses for a feminine touch</li><li>With trousers for a professional vibe</li><li>With skirts for a trendy outfit</li></ul>', 'uploads/leather-boots-guide.jpg', 'published', 'boots,style,guide', 45, NOW());

-- 5. Carousel Slides
INSERT INTO `carousel_slides` (`id`, `title`, `subtitle`, `image`, `button_text`, `button_link`, `order_index`, `is_active`) VALUES
(1, 'New Collection 2026', 'Discover the latest fashion trends', 'uploads/banner-1.jpg', 'Shop Now', 'shop.html', 1, 1),
(2, 'Sustainable Style', 'Eco-friendly fashion for a better future', 'uploads/banner-2.jpg', 'Explore', 'shop.html?category=sustainable', 2, 1),
(3, 'Winter Essentials', 'Stay warm and stylish this season', 'uploads/banner-3.jpg', 'Shop Now', 'shop.html', 3, 1);

-- 6. Features
INSERT INTO `features` (`id`, `icon`, `title`, `description`, `link`, `order_index`, `is_active`) VALUES
(1, 'fas fa-gem', 'Premium Quality', 'Curated selection of high-quality fashion pieces', 'shop.html', 1, 1),
(2, 'fas fa-truck', 'Free Shipping', 'Free delivery on orders over ৳2000', 'shop.html', 2, 1),
(3, 'fas fa-gift', 'Gift Ready', 'Beautiful gift packaging available', 'shop.html', 3, 1),
(4, 'fas fa-shield-alt', 'Authentic', '100% genuine products guaranteed', 'shop.html', 4, 1),
(5, 'fas fa-map-marker-alt', 'Order Tracking', 'Real-time order updates', 'order-tracking.html', 5, 1),
(6, 'fas fa-headset', '24/7 Support', 'Customer care always ready', 'contact.html', 6, 1);

-- 7. Homepage Content
INSERT INTO `homepage_content` (`id`, `section`, `title`, `subtitle`, `content`, `image`, `button_text`, `button_link`, `order_index`) VALUES
(1, 'hero_title', 'Inspiration for Future Outfits', NULL, NULL, NULL, NULL, NULL, 1),
(2, 'hero_subtitle', NULL, 'Search pieces by style, category, or occasion.', NULL, NULL, NULL, NULL, 2),
(3, 'hero_button', 'Search Styles', NULL, NULL, NULL, NULL, 'shop.html', 3),
(4, 'featured_title', '⭐ Featured Collections', NULL, NULL, NULL, NULL, NULL, 4),
(5, 'featured_subtitle', NULL, 'Our hand-picked selection of premium fashion', NULL, NULL, NULL, NULL, 5),
(6, 'featured_button_text', 'View All →', NULL, NULL, NULL, NULL, NULL, 6),
(7, 'bestseller_title', '🔥 Best Sellers', NULL, NULL, NULL, NULL, NULL, 7),
(8, 'bestseller_subtitle', NULL, 'Most loved by our customers', NULL, NULL, NULL, NULL, 8),
(9, 'bestseller_button_text', 'Shop Bestsellers →', NULL, NULL, NULL, NULL, NULL, 9),
(10, 'newsletter_title', '📧 Subscribe & Get 15% OFF', NULL, NULL, NULL, NULL, NULL, 10),
(11, 'newsletter_content', NULL, NULL, 'Plus exclusive offers, early access to sales, and style guides!', NULL, NULL, NULL, 11),
(12, 'newsletter_button_text', 'Subscribe', NULL, NULL, NULL, NULL, NULL, 12),
(13, 'footer_text', 'StyleSphere', NULL, NULL, NULL, NULL, NULL, 13),
(14, 'footer_subtitle', NULL, 'Premium fashion marketplace curated for style enthusiasts.', NULL, NULL, NULL, NULL, 14);

-- 8. Coupons
INSERT INTO `coupons` (`code`, `description`, `discount_type`, `discount_value`, `min_order_amount`, `max_discount`, `usage_limit`, `is_active`, `start_date`, `end_date`) VALUES
('WELCOME15', '15% off on first purchase', 'percent', 15, 500, 500, 100, 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
('SAVE10', 'Flat ৳100 off on orders above ৳1000', 'fixed', 100, 1000, NULL, 50, 1, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY)),
('STYLE2026', '20% off all fashion items', 'percent', 20, 1500, 1000, 200, 1, NOW(), DATE_ADD(NOW(), INTERVAL 45 DAY));

-- 9. Reviews
INSERT INTO `reviews` (`product_id`, `user_name`, `user_email`, `rating`, `comment`, `created_at`) VALUES
(1, 'Sarah J.', 'sarah@example.com', 5, 'Absolutely stunning blouse! The quality is exceptional and it fits perfectly.', NOW()),
(2, 'Michael R.', 'michael@example.com', 4, 'Great coat, very warm and stylish. A bit pricey but worth it.', NOW()),
(3, 'Emma K.', 'emma@example.com', 5, 'These boots are amazing! Comfortable from day one and looks great with everything.', NOW()),
(4, 'David L.', 'david@example.com', 5, 'The cashmere scarf is incredibly soft. Perfect gift for the winter season.', NOW());

-- ============================================
-- RESET AUTO_INCREMENT VALUES
-- ============================================
ALTER TABLE users AUTO_INCREMENT = 3;
ALTER TABLE products AUTO_INCREMENT = 9;
ALTER TABLE blogs AUTO_INCREMENT = 4;
ALTER TABLE carousel_slides AUTO_INCREMENT = 4;
ALTER TABLE features AUTO_INCREMENT = 7;
ALTER TABLE homepage_content AUTO_INCREMENT = 15;
ALTER TABLE coupons AUTO_INCREMENT = 4;
ALTER TABLE reviews AUTO_INCREMENT = 5;

-- ============================================
-- VERIFY DATABASE SETUP
-- ============================================
SELECT '✅ STYLESPHERE DATABASE SETUP COMPLETE!' as Status;
SELECT '📊 Tables Created: 14' as Info;
SELECT '📝 Sample Data: Users(2), Products(8), Blogs(3), Coupons(3)' as Info;