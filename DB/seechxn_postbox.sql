-- vrpfx 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `vrpfx`
USE `vrpfx`;

-- 테이블 vrpfx.seechxn_postbox 구조 내보내기
CREATE TABLE IF NOT EXISTS `seechxn_postbox` (
  `user_id` int DEFAULT NULL,
  `post_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `create_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `post_data` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '{}',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 vrpfx.seechxn_postbox:~1 rows 내보내기
DELETE FROM `seechxn_postbox`;
INSERT INTO `seechxn_postbox` (`user_id`, `post_id`, `create_at`, `post_data`) VALUES
	(1, '1', '2024-05-22 11:23:58', '{"title":"테스트","subTitle":"테스트","description":"플러그샵 테스트 입니다.<br>테스트인데요<br>감사합니다","itemList":[{"itemImage":"PlugS.png","itemCode":"PlugS_Coin","itemName":"10","itemAmount":"1"}]}');