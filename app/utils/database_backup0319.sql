/*
 Navicat Premium Dump SQL

 Source Server         : AmbuSmart
 Source Server Type    : MySQL
 Source Server Version : 90100 (9.1.0)
 Source Host           : localhost:3306
 Source Schema         : ambusmart

 Target Server Type    : MySQL
 Target Server Version : 90100 (9.1.0)
 File Encoding         : 65001

 Date: 19/03/2025 16:31:22
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for allergies
-- ----------------------------
DROP TABLE IF EXISTS `allergies`;
CREATE TABLE `allergies`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `allergy_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `severity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `from_patientid`(`patient_id` ASC) USING BTREE,
  CONSTRAINT `from_patientid` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of allergies
-- ----------------------------
INSERT INTO `allergies` VALUES (1, '123123123412341234', 'Pollen', 'Moderate', 'Seasonal allergy, primarily in spring');
INSERT INTO `allergies` VALUES (2, '123123123412341234', 'Peanuts', 'Severe', 'Anaphylactic reaction, requires immediate medical attention');
INSERT INTO `allergies` VALUES (3, '123123123412341234', '测试', '重度', 'string');

-- ----------------------------
-- Table structure for ambulance
-- ----------------------------
DROP TABLE IF EXISTS `ambulance`;
CREATE TABLE `ambulance`  (
  `aid` int NOT NULL AUTO_INCREMENT COMMENT '给救护车的一个表，暂时弃用，该系统对车本身没有存储需求。',
  `car_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`aid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ambulance
-- ----------------------------

-- ----------------------------
-- Table structure for basic_check
-- ----------------------------
DROP TABLE IF EXISTS `basic_check`;
CREATE TABLE `basic_check`  (
  `eid` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NULL DEFAULT NULL,
  `reject` int NULL DEFAULT 0 COMMENT '若1表示患者拒绝检查',
  `consciousness` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '神志 清醒/嗜睡/昏迷',
  `pupil` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '如2/2 表示左右',
  `pupillary_light_reflex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '对光反射 灵敏/迟钝/消失\r\n',
  `blood_pressure` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '血压 mmHg\r\n',
  `pulse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '脉搏 次/分',
  `respiration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '呼吸 次/分',
  `oxygen_saturation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '血氧饱和度 %',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`eid`) USING BTREE,
  INDEX `basicCheck_patient`(`patient_id` ASC) USING BTREE,
  CONSTRAINT `basicCheck_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 12009 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of basic_check
-- ----------------------------
INSERT INTO `basic_check` VALUES (12001, '2025-02-08 07:58:34', 0, '反正我上班上的神志不清', 'string', 'string', 'string', 'string', 'string', 'string', NULL);
INSERT INTO `basic_check` VALUES (12002, '2025-02-08 08:06:15', 0, '测试', 'string', 'string', 'string', 'okok', 'nonono', 'stri34234ng', NULL);
INSERT INTO `basic_check` VALUES (12003, '2025-02-19 17:09:32', 0, '测试1', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `basic_check` VALUES (12004, '2025-02-19 17:09:48', 0, '测试2', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `basic_check` VALUES (12005, '2025-02-19 18:25:23', 1, '清醒', '3/3', '灵敏', '110/70', '75', '16', '98', '123123200308281234');
INSERT INTO `basic_check` VALUES (12006, '2025-02-19 18:26:45', 0, '昏迷', '2/2', '迟钝', '80/70', '50', '10', '95', '123123200308281234');
INSERT INTO `basic_check` VALUES (12007, '2025-02-26 03:32:22', 0, '清醒', '2/2', '灵敏', '120', '70', '20', '98', NULL);
INSERT INTO `basic_check` VALUES (12008, '2025-02-26 03:32:29', 1, '', '', '', '', '', '', '', NULL);

-- ----------------------------
-- Table structure for case_histories
-- ----------------------------
DROP TABLE IF EXISTS `case_histories`;
CREATE TABLE `case_histories`  (
  `case_id` int NOT NULL AUTO_INCREMENT COMMENT '住院单，已剔除check',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门诊医师',
  `dno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `hospital` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `in_timestamp` datetime NULL DEFAULT NULL COMMENT '入院时间',
  `out_timestamp` datetime NULL DEFAULT NULL COMMENT '出院时间',
  `in_assessment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '入院病情',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `out_result` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '出院诊断',
  PRIMARY KEY (`case_id`) USING BTREE,
  INDEX `from_patientid`(`patient_id` ASC) USING BTREE,
  INDEX `from_wid`(`wid` ASC) USING BTREE,
  INDEX `med_department`(`dno` ASC) USING BTREE,
  CONSTRAINT `case_department` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `case_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `case_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10303 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of case_histories
-- ----------------------------
INSERT INTO `case_histories` VALUES (10300, '123123123412341234', NULL, NULL, NULL, NULL, NULL, 'test', NULL, 'test');
INSERT INTO `case_histories` VALUES (10301, '123123123412341234', 'w10001', 'b1', 'string', '2025-02-06 06:30:01', '2025-02-06 06:30:01', '入院病情', '测试1，仅有medicine', 'string');
INSERT INTO `case_histories` VALUES (10302, '123123123412341234', 'w1027', 'j1', NULL, '2025-02-19 15:14:10', '2025-02-19 15:14:13', '入院1', '测试2，各有2', '出院1');

-- ----------------------------
-- Table structure for chat_history
-- ----------------------------
DROP TABLE IF EXISTS `chat_history`;
CREATE TABLE `chat_history`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '对话ID',
  `operation_id` int NOT NULL COMMENT '关联急救操作ID',
  `user_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户发送的消息',
  `ai_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'AI 生成的回复',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '对话时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `operation_id`(`operation_id` ASC) USING BTREE,
  CONSTRAINT `chat_history_ibfk_1` FOREIGN KEY (`operation_id`) REFERENCES `operation_histories` (`operation_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_history
-- ----------------------------
INSERT INTO `chat_history` VALUES (1, 20245, '你好你好你好，快上车吧', '您好！看起来您可能有些着急。请告诉我具体发生了什么情况，我才能更好地为您提供帮助。如果需要紧急医疗救助，请立即拨打当地的急救电话（如中国的120）。我在接下来的对话中可以为您提供一些指导或建议，但不能替代专业的现场急救服务。\n\n如果您只是想表达热情，我也很高兴能与您交流！请告诉我您的问题或需求吧。 😊', '2025-03-19 16:27:56');
INSERT INTO `chat_history` VALUES (2, 20245, '现在患者快困死了，怎么办', '患者“快困死了”可能意味着患者感到极度疲惫、嗜睡，或者已经进入意识不清的状态。这种情况可能由多种原因引起，包括低血糖、缺氧、脑部问题、中毒、严重感染（如败血症）、药物副作用等。这是一个需要高度重视的情况。\n\n以下是一些紧急处理步骤，请根据实际情况选择操作：\n\n---\n\n### **1. 确保患者安全**\n- 如果患者已经失去意识或快要昏迷，请立即将其平躺，头偏向一侧，防止呕吐物误吸导致窒息。\n- 检查患者的呼吸和心跳：\n  - 如果没有呼吸或心跳，立即进行心肺复苏（CPR），并拨打急救电话（如中国的120）。\n  - 如果呼吸和心跳正常，继续下一步。\n\n---\n\n### **2. 呼叫急救**\n- **立即拨打急救电话**，清晰描述患者的症状、年龄、性别以及目前的状态（如“患者现在非常嗜睡，几乎无法唤醒”）。\n- 提供尽可能多的信息，例如是否有慢性疾病、近期是否服药或接触过有害物质等。\n\n---\n\n### **3. 初步检查和处理**\n在等待急救人员到来的同时，您可以尝试以下措施：\n- **检查血糖**：如果有可能，测量患者的血糖水平。低血糖可能导致嗜睡甚至昏迷。如果有血糖仪且血糖低于正常值（通常<3.9 mmol/L），可以给患者口服葡萄糖水或糖果（前提是患者还能吞咽）。如果无法确定血糖情况，不要贸然喂食。\n- **保持通风**：确保患者所处环境空气流通，避免缺氧。\n- **避免强行唤醒**：如果患者处于深度嗜睡状态，不要强行摇晃或刺激，以免造成二次伤害。\n- **观察其他症状**：注意患者是否有其他异常表现，例如皮肤苍白、发绀（嘴唇或指甲发紫）、抽搐、发热、呕吐等，并将这些信息告诉急救人员。\n\n---\n\n### **4. 不要随意用药**\n- 在没有明确诊断之前，切勿随意给患者服用任何药物，包括镇静剂、兴奋剂或其他处方药。\n\n---\n\n### **5. 可能的原因及线索**\n以下是一些可能导致患者极度嗜睡的常见原因，您可以回想一下患者近期的情况：\n- **低血糖**：糖尿病患者未按时进食或过量使用降糖药。\n- **脑部问题**：如中风、脑出血、脑炎等。\n- **中毒**：如一氧化碳中毒、酒精中毒、药物过量等。\n- **严重感染**：如败血症、脑膜炎。\n- **电解质紊乱**：如严重脱水或钠、钾水平异常。\n- **睡眠不足或疲劳过度**：虽然较少见，但长期缺乏休息也可能导致类似表现。\n\n---\n\n### **6. 等待专业救援**\n在急救人员到达之前，请密切观察患者的生命体征（呼吸、心跳、意识状态等），并随时向急救人员报告变化。\n\n---\n\n如果您还有更多具体信息（例如患者的基础疾病、近期活动或服药情况），请告诉我，我可以为您提供更针对性的建议！但无论如何，请尽快联系专业医疗团队到场处理。', '2025-03-19 16:29:11');
INSERT INTO `chat_history` VALUES (3, 20245, '先别管这个了，我叫peter', '好的，Peter！很高兴认识你。如果还有任何问题或需要帮助的地方，请随时告诉我！无论是医疗急救、健康咨询，还是其他方面的问题，我都会尽力为您提供支持。 😊\n\n您现在需要聊些什么呢？', '2025-03-19 16:29:40');
INSERT INTO `chat_history` VALUES (4, 20245, '刚刚患者主诉是什么，以及我叫什么', '好的，Peter！让我们回顾一下：\n\n- **患者的主诉**：患者感到极度疲惫、嗜睡，甚至快要失去意识（您描述为“快困死了”）。\n- **您的名字**：您叫 Peter。\n\n如果您还有其他问题或需要进一步的帮助，请随时告诉我！ 😊', '2025-03-19 16:30:00');

-- ----------------------------
-- Table structure for check_histories
-- ----------------------------
DROP TABLE IF EXISTS `check_histories`;
CREATE TABLE `check_histories`  (
  `check_id` int NOT NULL AUTO_INCREMENT COMMENT '检查信息，仅做内容，不考虑实际记录',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人员工号',
  `timestamp` datetime NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `result` blob NULL,
  `description` blob NULL,
  `cid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`check_id`) USING BTREE,
  INDEX `from_patientid`(`patient_id` ASC) USING BTREE,
  INDEX `from_wid`(`wid` ASC) USING BTREE,
  INDEX `to_checklist`(`cid` ASC) USING BTREE,
  CONSTRAINT `check_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_checklist` FOREIGN KEY (`cid`) REFERENCES `checks` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1008 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of check_histories
-- ----------------------------
INSERT INTO `check_histories` VALUES (1001, '123123123412341234', 'w1024', '2025-02-06 15:00:34', '测试记录', NULL, NULL, 'h3');
INSERT INTO `check_histories` VALUES (1002, '789789200101251234', 'w10001', '2025-02-06 18:10:36', NULL, NULL, NULL, 't0001');
INSERT INTO `check_histories` VALUES (1004, '123123123412341234', 'w10001', '2025-02-06 10:06:59', 'string', 0x737472696E67, 0xE6B58BE8AF9532, 't0001');
INSERT INTO `check_histories` VALUES (1005, '123123123412341234', 'w1025', '2025-02-07 14:54:29', '和1004是同一个门诊做的', NULL, NULL, 'h5');
INSERT INTO `check_histories` VALUES (1006, '123123123412341234', 'w1027', '2025-03-07 16:53:09', '给case1', NULL, NULL, 'h5');
INSERT INTO `check_histories` VALUES (1007, '123123123412341234', 'w1030', '2025-02-07 16:53:32', '给case1', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for check_relationship
-- ----------------------------
DROP TABLE IF EXISTS `check_relationship`;
CREATE TABLE `check_relationship`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用于记录检查和门诊/住院/急救的关系',
  `record_id` int NULL DEFAULT NULL,
  `case_id` int NULL DEFAULT NULL,
  `operation_id` int NULL DEFAULT NULL COMMENT '急救用',
  `check_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `check_recordmed`(`record_id` ASC) USING BTREE,
  INDEX `check_case`(`case_id` ASC) USING BTREE,
  INDEX `to_check`(`check_id` ASC) USING BTREE,
  INDEX `check_operation`(`operation_id` ASC) USING BTREE,
  CONSTRAINT `check_case` FOREIGN KEY (`case_id`) REFERENCES `case_histories` (`case_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_operation` FOREIGN KEY (`operation_id`) REFERENCES `operation_histories` (`operation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_recordmed` FOREIGN KEY (`record_id`) REFERENCES `medical_record` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_check` FOREIGN KEY (`check_id`) REFERENCES `check_histories` (`check_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of check_relationship
-- ----------------------------
INSERT INTO `check_relationship` VALUES (1, 10025, NULL, NULL, 1001);
INSERT INTO `check_relationship` VALUES (2, 10027, NULL, NULL, 1004);
INSERT INTO `check_relationship` VALUES (3, 10027, NULL, NULL, 1005);
INSERT INTO `check_relationship` VALUES (4, NULL, 10301, NULL, 1006);
INSERT INTO `check_relationship` VALUES (5, NULL, 10301, NULL, 1007);

-- ----------------------------
-- Table structure for checks
-- ----------------------------
DROP TABLE IF EXISTS `checks`;
CREATE TABLE `checks`  (
  `cid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `place` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `device` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `num` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`cid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of checks
-- ----------------------------
INSERT INTO `checks` VALUES ('h1', '尿肌红蛋白定性检查', '临床化验科', 4.00, '24hUTP', 11);
INSERT INTO `checks` VALUES ('h2', '尿血红蛋白定性检查', '临床化验科', 2.00, NULL, 1);
INSERT INTO `checks` VALUES ('h3', '局部切取组织活检检查与诊断', '临床化验科', 150.00, NULL, 0);
INSERT INTO `checks` VALUES ('h4', '免疫球蛋白IgA定量测定', '临床化验科', 10.00, NULL, 0);
INSERT INTO `checks` VALUES ('h5', '免疫组织化学染色诊断', '临床化验科', 109.00, NULL, 0);
INSERT INTO `checks` VALUES ('h6', '淋巴细胞免疫分析', '临床化验科', 30.00, NULL, 0);
INSERT INTO `checks` VALUES ('h7', '胸腹水常规检查', '临床化验科', 3.00, NULL, 5);
INSERT INTO `checks` VALUES ('m1', '针刺找过敏原（1组）', '临床免疫科', 20.00, NULL, 0);
INSERT INTO `checks` VALUES ('m2', '针刺找过敏原（≥2组）', '临床免疫科', 40.00, NULL, 0);
INSERT INTO `checks` VALUES ('m3', '免疫缺陷病毒(HIV)抗原抗体联合检测', '临床免疫科', 30.00, NULL, 1);
INSERT INTO `checks` VALUES ('n1', '关节镜检查', '内镜科', 200.00, NULL, 0);
INSERT INTO `checks` VALUES ('n10', '直肠镜检查', '内镜科', 40.00, NULL, 0);
INSERT INTO `checks` VALUES ('n11', '胸腔镜检查', '内镜科', 200.00, NULL, 1);
INSERT INTO `checks` VALUES ('n2', '内镜组织活检检查与诊断', '内镜科', 109.00, NULL, 0);
INSERT INTO `checks` VALUES ('n3', '小肠镜检查', '内镜科', 470.00, NULL, 0);
INSERT INTO `checks` VALUES ('n4', '食管镜检查', '内镜科', 50.00, NULL, 0);
INSERT INTO `checks` VALUES ('n5', '鼻内镜检查', '内镜科', 3.00, NULL, 0);
INSERT INTO `checks` VALUES ('n6', '腹腔镜检查', '内镜科', 300.00, NULL, 0);
INSERT INTO `checks` VALUES ('n7', '膀胱镜尿道镜检查', '内镜科', 180.00, NULL, 0);
INSERT INTO `checks` VALUES ('n8', '肛门镜检查', '内镜科', 20.00, NULL, 0);
INSERT INTO `checks` VALUES ('n9', '结肠镜检查', '内镜科', 400.00, NULL, 0);
INSERT INTO `checks` VALUES ('t0001', '测试数据', 'string', 110.00, 'string', 10);
INSERT INTO `checks` VALUES ('t0002', 'test', NULL, NULL, NULL, 0);
INSERT INTO `checks` VALUES ('t1', '三棱镜检查', '眼科', 5.00, NULL, 0);
INSERT INTO `checks` VALUES ('t10', '视网膜视力检查', '眼科', 5.00, NULL, 1);
INSERT INTO `checks` VALUES ('t11', '眼科常规检查', '眼科', 5.00, NULL, 3);
INSERT INTO `checks` VALUES ('t12', '甲状腺功能常规检查', '普通内科', 125.00, NULL, 0);
INSERT INTO `checks` VALUES ('t13', '肝功能常规检查', '普通内科', 31.00, NULL, 0);
INSERT INTO `checks` VALUES ('t14', '牙周常规检查', '牙科', 1.00, NULL, 0);
INSERT INTO `checks` VALUES ('t15', '肾功能常规检查', '普通内科', 12.00, NULL, 0);
INSERT INTO `checks` VALUES ('t16', '肛门指检', '普通内科', 3.00, NULL, 0);
INSERT INTO `checks` VALUES ('t17', '特殊视力检查', '眼科', 2.00, NULL, 0);
INSERT INTO `checks` VALUES ('t2', '上睑下垂检查', '眼科', 2.00, NULL, 0);
INSERT INTO `checks` VALUES ('t3', '义齿压痛定位仪检查', '牙科', 1.00, NULL, 0);
INSERT INTO `checks` VALUES ('t4', '口腔常规检查', '牙科', 5.00, NULL, 0);
INSERT INTO `checks` VALUES ('t5', '喉动态镜检查', '耳鼻喉科', 50.00, NULL, 0);
INSERT INTO `checks` VALUES ('t6', '妇科常规检查', '妇科', 13.00, NULL, 0);
INSERT INTO `checks` VALUES ('t7', '常规心电图检查', '普通内科', 20.00, NULL, 0);
INSERT INTO `checks` VALUES ('t8', '面神经肌电图检查', '普通内科', 20.00, NULL, 0);
INSERT INTO `checks` VALUES ('t9', '角膜刮片检查（单眼）', '眼科', 10.00, NULL, 0);
INSERT INTO `checks` VALUES ('w1', '一般细菌涂片检查', '临床微生物科', 5.00, NULL, 1);
INSERT INTO `checks` VALUES ('w10', '异常红细胞形态检查', '临床微生物科', 1.00, NULL, 0);
INSERT INTO `checks` VALUES ('w11', '淋巴细胞免疫分析', '临床微生物科', 30.00, NULL, 0);
INSERT INTO `checks` VALUES ('w2', '内窥镜刷片脱落细胞学检查与诊断', '临床微生物科', 55.00, NULL, 0);
INSERT INTO `checks` VALUES ('w3', '囊肿穿刺液细胞学检查与诊断', '临床微生物科', 39.00, NULL, 0);
INSERT INTO `checks` VALUES ('w4', '子宫内膜脱落细胞学检查与诊断', '临床微生物科', 55.00, NULL, 0);
INSERT INTO `checks` VALUES ('w5', '结核菌涂片检查', '临床微生物科', 8.00, NULL, 0);
INSERT INTO `checks` VALUES ('w6', '巨噬细胞吞噬功能试验', '临床微生物科', 10.00, NULL, 0);
INSERT INTO `checks` VALUES ('w7', '外周血淋巴细胞微核试验', '临床微生物科', 280.00, NULL, 0);
INSERT INTO `checks` VALUES ('w8', '抗体依赖性细胞毒性试验', '临床微生物科', 15.00, NULL, 0);
INSERT INTO `checks` VALUES ('w9', '快速细胞病理诊断', '临床微生物科', 105.00, NULL, 0);
INSERT INTO `checks` VALUES ('x1', '凝血功能常规检查', '血液科', 48.00, NULL, 0);
INSERT INTO `checks` VALUES ('x10', '病毒血清学试验', '血液科', 20.00, NULL, 1);
INSERT INTO `checks` VALUES ('x2', '血清渗透压检查', '血液科', 10.00, NULL, 0);
INSERT INTO `checks` VALUES ('x3', '血细胞染色体检查', '血液科', 39.00, NULL, 0);
INSERT INTO `checks` VALUES ('x4', '血脂常规检查', '血液科', 19.00, NULL, 0);
INSERT INTO `checks` VALUES ('x5', '血清过敏原特异IgG测定', '血液科', 10.00, NULL, 0);
INSERT INTO `checks` VALUES ('x6', 'ABO血型鉴定', '血液科', 8.00, NULL, 0);
INSERT INTO `checks` VALUES ('x7', '血型抗原鉴定', '血液科', 15.00, NULL, 0);
INSERT INTO `checks` VALUES ('x8', '冷溶血试验', '血液科', 4.00, NULL, 0);
INSERT INTO `checks` VALUES ('x9', '快速血浆反应素试验(RPR)', '血液科', 5.00, NULL, 0);
INSERT INTO `checks` VALUES ('y1', 'CT增强扫描(一个部位)', '医学影像科', 140.00, '西门子128排螺旋CT', 0);
INSERT INTO `checks` VALUES ('y10', '胎儿系统彩色多普勒超声检查', '医学影像科', 270.00, NULL, 0);
INSERT INTO `checks` VALUES ('y2', 'CT平扫(一个部位)', '医学影像科', 80.00, '西门子128排螺旋CT', 0);
INSERT INTO `checks` VALUES ('y3', '磁共振扫描MRI', '医学影像科', 500.00, 'GE Discovery MR750 3.0T研究型磁共振成像仪', 0);
INSERT INTO `checks` VALUES ('y4', 'PET/MR 局部显像', '医学影像科', 6600.00, '飞利浦GEMINI TF PET/CT系统', 0);
INSERT INTO `checks` VALUES ('y5', 'PET/MR 全身显像', '医学影像科', 11000.00, '飞利浦GEMINI TF PET/CT系统', 0);
INSERT INTO `checks` VALUES ('y6', 'A型超声检查(一个部位)', '医学影像科', 2.00, NULL, 0);
INSERT INTO `checks` VALUES ('y7', 'B超常规检查(一个部位)', '医学影像科', 15.00, NULL, 0);
INSERT INTO `checks` VALUES ('y8', 'B超检查（孕、环情）', '医学影像科', 5.00, NULL, 0);
INSERT INTO `checks` VALUES ('y9', '彩色多普勒超声常规检查(一个部位)', '医学影像科', 70.00, NULL, 0);

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `dno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`dno`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES ('b1', '耳鼻喉科', '耳鼻喉科');
INSERT INTO `department` VALUES ('e1', '儿科', '儿科');
INSERT INTO `department` VALUES ('f1', '妇科', '妇产科');
INSERT INTO `department` VALUES ('f2', '产科', '妇产科');
INSERT INTO `department` VALUES ('g1', '骨科', '骨科');
INSERT INTO `department` VALUES ('g2', '骨科（创伤）', '骨科');
INSERT INTO `department` VALUES ('h1', '后勤1', '后勤');
INSERT INTO `department` VALUES ('h2', '护理', '护理');
INSERT INTO `department` VALUES ('h3', '后勤2', '后勤');
INSERT INTO `department` VALUES ('j1', '血液科', '部门');
INSERT INTO `department` VALUES ('j2', '医学影像科', '部门');
INSERT INTO `department` VALUES ('j3', '体外检查科', '部门');
INSERT INTO `department` VALUES ('j4', '临床化验科', '部门');
INSERT INTO `department` VALUES ('j5', '临床免疫科', '部门');
INSERT INTO `department` VALUES ('j6', '临床微生物科', '部门');
INSERT INTO `department` VALUES ('j7', '内镜科', '部门');
INSERT INTO `department` VALUES ('k1', '口腔科', '口腔科');
INSERT INTO `department` VALUES ('n1', '普通内科', '内科');
INSERT INTO `department` VALUES ('n2', '血液内科', '内科');
INSERT INTO `department` VALUES ('n3', '风湿免疫科', '内科');
INSERT INTO `department` VALUES ('n4', '心血管内科', '内科');
INSERT INTO `department` VALUES ('n5', '呼吸与危重症医学科', '内科');
INSERT INTO `department` VALUES ('n6', '内分泌代谢科', '内科');
INSERT INTO `department` VALUES ('n7', '消化内科', '内科');
INSERT INTO `department` VALUES ('n8', '肾内科', '内科');
INSERT INTO `department` VALUES ('n9', '内分泌科', '内科');
INSERT INTO `department` VALUES ('p1', '皮肤科', '皮肤科');
INSERT INTO `department` VALUES ('q1', '抢救员', '抢救');
INSERT INTO `department` VALUES ('test01', '测试', '内科');
INSERT INTO `department` VALUES ('w1', '普通外科', '外科');
INSERT INTO `department` VALUES ('w2', '特诊外科', '外科');
INSERT INTO `department` VALUES ('w3', '神经外科', '外科');
INSERT INTO `department` VALUES ('w4', '泌尿外科', '外科');
INSERT INTO `department` VALUES ('w5', '胸心外科', '外科');
INSERT INTO `department` VALUES ('w6', '整形科', '外科');
INSERT INTO `department` VALUES ('w7', '甲状腺外科', '外科');
INSERT INTO `department` VALUES ('w8', '乳腺外科', '外科');
INSERT INTO `department` VALUES ('y1', '眼科', '眼科');
INSERT INTO `department` VALUES ('z1', '肿瘤科', '肿瘤科');
INSERT INTO `department` VALUES ('zy1', '中医伤科', '中医科');
INSERT INTO `department` VALUES ('zy2', '中医针灸科', '中医科');

-- ----------------------------
-- Table structure for health_personnel
-- ----------------------------
DROP TABLE IF EXISTS `health_personnel`;
CREATE TABLE `health_personnel`  (
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `job` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `age` int NULL DEFAULT NULL,
  PRIMARY KEY (`wid`) USING BTREE,
  INDEX `dno`(`dno` ASC, `wid` ASC) USING BTREE,
  INDEX `dno_2`(`dno` ASC, `wid` ASC, `name` ASC) USING BTREE,
  INDEX `job`(`job` ASC, `wid` ASC) USING BTREE,
  INDEX `wid`(`wid` ASC, `job` ASC, `dno` ASC) USING BTREE,
  INDEX `hp2`(`wid` ASC, `dno` ASC, `name` ASC) USING BTREE,
  CONSTRAINT `health_personnel_ibfk_1` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of health_personnel
-- ----------------------------
INSERT INTO `health_personnel` VALUES ('d5201', 'h1', '冯昊测', '司机', '男', '420101196402108602', 50);
INSERT INTO `health_personnel` VALUES ('d5202', 'h1', '吕实堂', '司机', '男', '420101197905266631', 49);
INSERT INTO `health_personnel` VALUES ('d5203', 'h1', '周所龄', '司机', '男', '420101198509121291', 45);
INSERT INTO `health_personnel` VALUES ('d5204', 'h1', '阮新巧', '司机', '男', '225080199206131000', 32);
INSERT INTO `health_personnel` VALUES ('d5205', 'h1', '黎白卉', '司机', '女', '44613219880524926X', 36);
INSERT INTO `health_personnel` VALUES ('d5206', 'h1', '缑安雁', '司机', '男', '116486198402088000', 38);
INSERT INTO `health_personnel` VALUES ('d5207', 'h1', '郏小凡', '司机', '男', '130491198911073000', 35);
INSERT INTO `health_personnel` VALUES ('d5208', 'h1', '柴问安', '司机', '男', '238563197911040000', 48);
INSERT INTO `health_personnel` VALUES ('d5209', 'h1', '陈周', '司机', '男', '123123456145617894', 40);
INSERT INTO `health_personnel` VALUES ('h3209', 'h2', '昝晓兰', '护士', '女', '442017196810081000', 50);
INSERT INTO `health_personnel` VALUES ('h3210', 'h2', '姜青筠', '护士', '女', '217520198709074000', 36);
INSERT INTO `health_personnel` VALUES ('h3211', 'h2', '索友儿', '护士', '女', '335209198709187000', 36);
INSERT INTO `health_personnel` VALUES ('h3212', 'h2', '曾沛儿', '护士', '女', '355505197508046000', 45);
INSERT INTO `health_personnel` VALUES ('h3213', 'h2', '籍觅珍', '护士', '女', '651653200607209000', 25);
INSERT INTO `health_personnel` VALUES ('h3214', 'h2', '闻曼香', '护士', '女', '824552199105317000', 30);
INSERT INTO `health_personnel` VALUES ('h3215', 'h2', '蔺南松', '护士', '女', '130465199403166000', 32);
INSERT INTO `health_personnel` VALUES ('h3216', 'h2', '司徒孤丝', '护士', '女', '422866199404218000', 32);
INSERT INTO `health_personnel` VALUES ('h3217', 'h2', '于青曼', '护士', '女', '507017198209055000', 39);
INSERT INTO `health_personnel` VALUES ('h3218', 'h2', '水又菡', '护士', '男', '119549198601250000', 35);
INSERT INTO `health_personnel` VALUES ('h3219', 'h2', '柴千兰', '护士', '女', '215374200409144000', 26);
INSERT INTO `health_personnel` VALUES ('h3220', 'h2', '杨元霜', '护士', '男', '822443197903249000', 38);
INSERT INTO `health_personnel` VALUES ('h3221', 'h2', '焦夏彤', '护士', '女', '622609199007040000', 35);
INSERT INTO `health_personnel` VALUES ('h3222', 'h2', '饶元枫', '护士', '女', '820640197205158000', 38);
INSERT INTO `health_personnel` VALUES ('h3223', 'h2', '崔晓瑶', '护士', '女', '214786199610173000', 31);
INSERT INTO `health_personnel` VALUES ('h3224', 'h2', '太叔向雪', '护士', '女', '520701198205223000', 39);
INSERT INTO `health_personnel` VALUES ('h3225', 'h2', '郦安蕾', '护士', '女', '22997919620704202X', 39);
INSERT INTO `health_personnel` VALUES ('h3226', 'h2', '养冷珍', '护士', '女', '321389200105125000', 24);
INSERT INTO `health_personnel` VALUES ('j8090', 'h3', '云傲蕾', '担架工', '女', '838276199006146000', 31);
INSERT INTO `health_personnel` VALUES ('j8091', 'h3', '澹台以蕊', '担架工', '女', '459311198806178000', 38);
INSERT INTO `health_personnel` VALUES ('j8092', 'h3', '贾绮彤', '担架工', '男', '123025196707161000', 39);
INSERT INTO `health_personnel` VALUES ('j8093', 'h3', '皮如松', '担架工', '男', '353267196008140000', 45);
INSERT INTO `health_personnel` VALUES ('j8094', 'h3', '冷山雁', '担架工', '男', '125393200302246000', 36);
INSERT INTO `health_personnel` VALUES ('j8095', 'h3', '季从安', '担架工', '男', '450692198102134000', 38);
INSERT INTO `health_personnel` VALUES ('j8096', 'h3', '古乐菱', '担架工', '男', '415052200210078000', 47);
INSERT INTO `health_personnel` VALUES ('w10001', 'g1', '田柾国', '医生', '男', '123456199709011234', 25);
INSERT INTO `health_personnel` VALUES ('w1023', 'b1', '钟如妙', '医生', '男', '220281199502038962', 28);
INSERT INTO `health_personnel` VALUES ('w1024', 'b1', '幸葵樱', '副高', '女', '469021197902212545', 44);
INSERT INTO `health_personnel` VALUES ('w1025', 'b1', '倪楷准', '正高', '男', '130926194709277323', 75);
INSERT INTO `health_personnel` VALUES ('w1026', 'b1', '司涓娟', '精英', '女', '140781198307111440', 40);
INSERT INTO `health_personnel` VALUES ('w1027', 'b1', '经华晔', '医生', '男', '130284198711145083', 35);
INSERT INTO `health_personnel` VALUES ('w1028', 'e1', '萧延高', '医生', '男', '640221198809254600', 34);
INSERT INTO `health_personnel` VALUES ('w1029', 'e1', '怀歆珣', '医生', '男', '360830198404107705', 39);
INSERT INTO `health_personnel` VALUES ('w1030', 'e1', '滑嵘红', '正高', '女', '370685197502106617', 48);
INSERT INTO `health_personnel` VALUES ('w1031', 'e1', '计胤翔', '精英', '男', '330213197608250480', 47);
INSERT INTO `health_personnel` VALUES ('w1032', 'e1', '张延旗', '医生', '女', '63272319291229447X', 93);
INSERT INTO `health_personnel` VALUES ('w1033', 'e1', '詹连野', '医生', '男', '361103195202293762', 71);
INSERT INTO `health_personnel` VALUES ('w1034', 'f1', '姜沫蒙', '医生', '女', '13028319761117353X', 46);
INSERT INTO `health_personnel` VALUES ('w1035', 'f1', '邴鹰品', '医生', '男', '510725199709040963', 25);
INSERT INTO `health_personnel` VALUES ('w1036', 'f1', '窦方纲', '副高', '女', '411121198704235934', 36);
INSERT INTO `health_personnel` VALUES ('w1037', 'f1', '贡可亚', '副高', '男', '520628200104210617', 22);
INSERT INTO `health_personnel` VALUES ('w1038', 'f2', '常一泉', '医生', '女', '220523199202216760', 31);
INSERT INTO `health_personnel` VALUES ('w1039', 'f2', '史桦汉', '正高', '男', '621121198301078136', 40);
INSERT INTO `health_personnel` VALUES ('w1040', 'f2', '仰泉璋', '精英', '女', '130207200109055461', 22);
INSERT INTO `health_personnel` VALUES ('w1041', 'f2', '田卉巧', '精英', '男', '421002198612299102', 36);
INSERT INTO `health_personnel` VALUES ('w1042', 'g1', '祖梓展', '精英', '男', '410781199905289819', 24);
INSERT INTO `health_personnel` VALUES ('w1043', 'g1', '顾普彬', '副高', '女', '150603199107233695', 32);
INSERT INTO `health_personnel` VALUES ('w1044', 'g1', '樊耘栋', '医生', '男', '530828200112222717', 21);
INSERT INTO `health_personnel` VALUES ('w1045', 'g1', '宗萍言', '副高', '女', '632821198704010369', 36);
INSERT INTO `health_personnel` VALUES ('w1046', 'g2', '缪慈春', '精英', '男', '420324192403280129', 99);
INSERT INTO `health_personnel` VALUES ('w1047', 'g2', '白蔷霁', '精英', '女', '441521197710029291', 45);
INSERT INTO `health_personnel` VALUES ('w1048', 'g2', '包曼睿', '医生', '男', '610803197806280717', 45);
INSERT INTO `health_personnel` VALUES ('w1049', 'k1', '杭前然', '医生', '男', '440705199209046273', 30);
INSERT INTO `health_personnel` VALUES ('w1050', 'k1', '怀靖闽', '副高', '男', '360313198904231079', 34);
INSERT INTO `health_personnel` VALUES ('w1051', 'k1', '卓京品', '正高', '女', '360726197612318286', 46);
INSERT INTO `health_personnel` VALUES ('w1052', 'k1', '万微洵', '精英', '男', '341322200312095142', 19);
INSERT INTO `health_personnel` VALUES ('w1053', 'n1', '胡晓寒', '医生', '女', '45102219680428429X', 55);
INSERT INTO `health_personnel` VALUES ('w1054', 'n1', '乌通赞', '医生', '男', '230805197008310955', 52);
INSERT INTO `health_personnel` VALUES ('w1055', 'n1', '汪梦游', '医生', '女', '53332319850725237X', 38);
INSERT INTO `health_personnel` VALUES ('w1056', 'n1', '陈霁珠', '医生', '男', '510823198407123729', 39);
INSERT INTO `health_personnel` VALUES ('w1057', 'n1', '江绚姣', '医生', '女', '513422198506293971', 38);
INSERT INTO `health_personnel` VALUES ('w1058', 'n1', '束玮彬', '副高', '男', '411481197302054322', 40);
INSERT INTO `health_personnel` VALUES ('w1059', 'n1', '马诚漫', '医生', '女', '150927196304298416', 60);
INSERT INTO `health_personnel` VALUES ('w1060', 'n1', '严通寒', '正高', '男', '210204197107166543', 52);
INSERT INTO `health_personnel` VALUES ('w1061', 'n1', '富庆令', '精英', '女', '654022196309176574', 59);
INSERT INTO `health_personnel` VALUES ('w1062', 'n2', '俞逸华', '精英', '男', '13082119800918205X', 42);
INSERT INTO `health_personnel` VALUES ('w1063', 'n2', '孟力田', '精英', '男', '211421193412177804', 88);
INSERT INTO `health_personnel` VALUES ('w1064', 'n2', '汪贞艳', '副高', '女', '350423200905103745', 14);
INSERT INTO `health_personnel` VALUES ('w1065', 'n2', '陈铖曙', '医生', '男', '420322196011036181', 62);
INSERT INTO `health_personnel` VALUES ('w1066', 'n3', '胡茉惠', '副高', '女', '410205194412094953', 78);
INSERT INTO `health_personnel` VALUES ('w1067', 'n3', '汤岚卿', '正高', '男', '130981201004243921', 13);
INSERT INTO `health_personnel` VALUES ('w1068', 'n3', '宫巧嫒', '精英', '女', '510115194306214406', 80);
INSERT INTO `health_personnel` VALUES ('w1069', 'n3', '崔弘泽', '医生', '男', '130408196709230671', 55);
INSERT INTO `health_personnel` VALUES ('w1070', 'n3', '邓春蔷', '医生', '女', '360402198604076610', 37);
INSERT INTO `health_personnel` VALUES ('w1071', 'n4', '孟莹或', '医生', '男', '370105191963126997', 54);
INSERT INTO `health_personnel` VALUES ('w1072', 'n4', '齐知蓓', '医生', '女', '371423201306079965', 10);
INSERT INTO `health_personnel` VALUES ('w1073', 'n4', '强丽予', '副高', '男', '511525197407060570', 49);
INSERT INTO `health_personnel` VALUES ('w1074', 'n4', '蒙庚淼', '副高', '女', '411381198401141288', 39);
INSERT INTO `health_personnel` VALUES ('w1075', 'n4', '舒咏舟', '医生', '男', '150523200310224757', 19);
INSERT INTO `health_personnel` VALUES ('w1076', 'n5', '樊灵葵', '正高', '女', '610328191609039898', 106);
INSERT INTO `health_personnel` VALUES ('w1077', 'n5', '梅晋州', '精英', '男', '420205201103264378', 12);
INSERT INTO `health_personnel` VALUES ('w1078', 'n5', '白婕冶', '精英', '男', '520627197808248823', 44);
INSERT INTO `health_personnel` VALUES ('w1079', 'n5', '马珣果', '精英', '女', '150429194803214746', 75);
INSERT INTO `health_personnel` VALUES ('w1080', 'n5', '管向昌', '副高', '男', '421124201301159100', 10);
INSERT INTO `health_personnel` VALUES ('w1081', 'n6', '裴纪韵', '医生', '女', '410411191511022810', 107);
INSERT INTO `health_personnel` VALUES ('w1082', 'n6', '蓬韶铖', '副高', '男', '511421191001257190', 113);
INSERT INTO `health_personnel` VALUES ('w1083', 'n6', '舒韵珍', '正高', '男', '500115198502144237', 38);
INSERT INTO `health_personnel` VALUES ('w1084', 'n7', '孔郁懿', '精英', '女', '15042819950719461X', 28);
INSERT INTO `health_personnel` VALUES ('w1085', 'n7', '孙欣霁', '医生', '男', '370682196903267215', 54);
INSERT INTO `health_personnel` VALUES ('w1086', 'n7', '贺云妮', '医生', '女', '622927199705301899', 26);
INSERT INTO `health_personnel` VALUES ('w1087', 'n7', '马杉韶', '副高', '男', '130725199709158952', 25);
INSERT INTO `health_personnel` VALUES ('w1088', 'n7', '郁前旗', '正高', '男', '230505191205062720', 111);
INSERT INTO `health_personnel` VALUES ('w1089', 'n8', '单广润', '精英', '男', '140215201304208298', 10);
INSERT INTO `health_personnel` VALUES ('w1090', 'n8', '方珑爱', '医生', '女', '430181190905270990', 114);
INSERT INTO `health_personnel` VALUES ('w1091', 'n8', '吉起嵘', '医生', '男', '220503191505090577', 108);
INSERT INTO `health_personnel` VALUES ('w1092', 'n8', '戴年纲', '医生', '女', '330902197702067403', 46);
INSERT INTO `health_personnel` VALUES ('w1093', 'n9', '单帅丛', '医生', '男', '440310190402060518', 119);
INSERT INTO `health_personnel` VALUES ('w1094', 'n9', '姜河孝', '副高', '女', '150624201302146900', 10);
INSERT INTO `health_personnel` VALUES ('w1095', 'n9', '胡蕴旖', '副高', '男', '130928194807035806', 75);
INSERT INTO `health_personnel` VALUES ('w1096', 'n9', '罗雷年', '医生', '女', '510321193006209035', 93);
INSERT INTO `health_personnel` VALUES ('w1097', 'p1', '彭驰竹', '正高', '男', '450502195810098537', 64);
INSERT INTO `health_personnel` VALUES ('w1098', 'p1', '尹如晓', '精英', '女', '410302191905212244', 104);
INSERT INTO `health_personnel` VALUES ('w1099', 'p1', '苏倩悦', '医生', '男', '430482201107021766', 12);
INSERT INTO `health_personnel` VALUES ('w1100', 'p1', '孙隽华', '副高', '女', '320106201412146460', 8);
INSERT INTO `health_personnel` VALUES ('w1101', 'w1', '杨珩融', '正高', '男', '152526193705297326', 86);
INSERT INTO `health_personnel` VALUES ('w1102', 'w1', '田艺建', '精英', '男', '210624199602205892', 27);
INSERT INTO `health_personnel` VALUES ('w1103', 'w1', '白燕纯', '医生', '女', '511603194102272076', 82);
INSERT INTO `health_personnel` VALUES ('w1104', 'w1', '韦栋澄', '医生', '男', '445203198210123870', 40);
INSERT INTO `health_personnel` VALUES ('w1105', 'w1', '单罡凯', '医生', '女', '45020419850417807X', 38);
INSERT INTO `health_personnel` VALUES ('w1106', 'w1', '芮升纲', '医生', '男', '370602195107173828', 72);
INSERT INTO `health_personnel` VALUES ('w1107', 'w1', '葛耀铮', '副高', '女', '220781192807172636', 95);
INSERT INTO `health_personnel` VALUES ('w1108', 'w2', '鲍千展', '副高', '男', '621027192202244800', 101);
INSERT INTO `health_personnel` VALUES ('w1109', 'w2', '嵇喆格', '医生', '男', '53292319560116496X', 67);
INSERT INTO `health_personnel` VALUES ('w1110', 'w2', '滑彩怡', '正高', '男', '451424200301104262', 20);
INSERT INTO `health_personnel` VALUES ('w1111', 'w3', '宁琚兰', '精英', '女', '340621196402271218', 59);
INSERT INTO `health_personnel` VALUES ('w1112', 'w3', '邬筝乐', '精英', '男', '510821195803080365', 65);
INSERT INTO `health_personnel` VALUES ('w1113', 'w3', '毕舟立', '精英', '女', '230307199610091179', 26);
INSERT INTO `health_personnel` VALUES ('w1114', 'w3', '滕芊振', '副高', '男', '654025191307183523', 110);
INSERT INTO `health_personnel` VALUES ('w1115', 'w4', '伏依艳', '医生', '女', '530129194308070946', 80);
INSERT INTO `health_personnel` VALUES ('w1116', 'w4', '左影真', '副高', '男', '430281194706295662', 76);
INSERT INTO `health_personnel` VALUES ('w1117', 'w4', '邢予煦', '正高', '女', '411526190506083383', 118);
INSERT INTO `health_personnel` VALUES ('w1118', 'w5', '娄莉妲', '精英', '男', '150221200411297518', 18);
INSERT INTO `health_personnel` VALUES ('w1119', 'w5', '凤琛起', '医生', '女', '640324199902043796', 24);
INSERT INTO `health_personnel` VALUES ('w1120', 'w5', '韦鹭婧', '医生', '男', '370213193901097584', 84);
INSERT INTO `health_personnel` VALUES ('w1121', 'w5', '宁佩晔', '副高', '女', '140303192806228625', 95);
INSERT INTO `health_personnel` VALUES ('w1122', 'w5', '章星情', '正高', '男', '410702193509121384', 87);
INSERT INTO `health_personnel` VALUES ('w1123', 'w6', '虞歌硕', '精英', '男', '620121190507112195', 118);
INSERT INTO `health_personnel` VALUES ('w1124', 'w6', '齐瑾怀', '医生', '女', '410182191705263830', 106);
INSERT INTO `health_personnel` VALUES ('w1125', 'w6', '解芬涓', '医生', '男', '210803196811173909', 54);
INSERT INTO `health_personnel` VALUES ('w1126', 'w7', '房辰旖', '医生', '女', '370827194111187759', 81);
INSERT INTO `health_personnel` VALUES ('w1127', 'w7', '任焘蔚', '医生', '男', '21010619820705898X', 41);
INSERT INTO `health_personnel` VALUES ('w1128', 'w7', '马文晓', '副高', '女', '430623190907205213', 114);
INSERT INTO `health_personnel` VALUES ('w1129', 'w7', '左中崧', '副高', '男', '53090219501030172X', 72);
INSERT INTO `health_personnel` VALUES ('w1130', 'w8', '童齐克', '医生', '女', '230723191601079587', 107);
INSERT INTO `health_personnel` VALUES ('w1131', 'w8', '符博原', '副高', '男', '370306195912206417', 63);
INSERT INTO `health_personnel` VALUES ('w1132', 'w8', '马澄翌', '正高', '女', '440802193812228273', 84);
INSERT INTO `health_personnel` VALUES ('w1133', 'y1', '纪劲朴', '精英', '男', '361102191001313929', 113);
INSERT INTO `health_personnel` VALUES ('w1134', 'y1', '乔馨凡', '医生', '女', '130205200004152158', 23);
INSERT INTO `health_personnel` VALUES ('w1135', 'y1', '蒙严信', '医生', '男', '15012219561214673X', 66);
INSERT INTO `health_personnel` VALUES ('w1136', 'y1', '娄能格', '医生', '女', '150103195207024633', 71);
INSERT INTO `health_personnel` VALUES ('w1137', 'y1', '虞涌默', '医生', '男', '211224200307025703', 20);
INSERT INTO `health_personnel` VALUES ('w1138', 'y1', '韶羽耿', '副高', '男', '510725196511221626', 57);
INSERT INTO `health_personnel` VALUES ('w1139', 'j1', '贺韬遥', '副高', '女', '522326200403268168', 19);
INSERT INTO `health_personnel` VALUES ('w1140', 'j1', '水岩勉', '医生', '男', '350322194002054719', 83);
INSERT INTO `health_personnel` VALUES ('w1141', 'j1', '井孝辰', '医生', '男', '130207194508184748', 77);
INSERT INTO `health_personnel` VALUES ('w1142', 'j1', '郜傲奕', '精英', '女', '420303198805249410', 35);
INSERT INTO `health_personnel` VALUES ('w1143', 'z1', '黄斐莉', '正高', '男', '140223200705101737', 16);
INSERT INTO `health_personnel` VALUES ('w1144', 'z1', '单添红', '精英', '男', '440105199902036775', 24);
INSERT INTO `health_personnel` VALUES ('w1145', 'z1', '龙沁妮', '副高', '男', '370684191905303849', 104);
INSERT INTO `health_personnel` VALUES ('w1146', 'z1', '符金渝', '医生', '女', '620121190310271862', 119);
INSERT INTO `health_personnel` VALUES ('w1147', 'q1', '汪奇栋', '副高', '男', '632726197707048466', 46);
INSERT INTO `health_personnel` VALUES ('w1148', 'q1', '缪溢昌', '正高', '女', '440512193205309262', 91);
INSERT INTO `health_personnel` VALUES ('w1149', 'q1', '祝闽坦', '精英', '男', '340826199403184198', 29);
INSERT INTO `health_personnel` VALUES ('w1150', 'q1', '邢允文', '医生', '女', '32098119110817523X', 111);
INSERT INTO `health_personnel` VALUES ('w1151', 'q1', '黄严帆', '医生', '男', '330205192807288892', 95);
INSERT INTO `health_personnel` VALUES ('w1152', 'zy2', '吕雍琼', '副高', '女', '220202199712205940', 25);
INSERT INTO `health_personnel` VALUES ('w1153', 'zy2', '秋琴栋', '正高', '男', '360821199411239170', 28);
INSERT INTO `health_personnel` VALUES ('w1154', 'zy2', '咎弘璋', '精英', '女', '130321193904034934', 84);
INSERT INTO `health_personnel` VALUES ('w1155', 'q1', '程俐璇', '医生', '男', '53282319161129254X', 106);
INSERT INTO `health_personnel` VALUES ('w1156', 'q1', '龚珍安', '医生', '女', '152529199911037134', 23);
INSERT INTO `health_personnel` VALUES ('w1157', 'q1', '宋垒辉', '医生', '男', '350702197508106694', 48);
INSERT INTO `health_personnel` VALUES ('w1158', 'q1', '翁玉蓉', '医生', '男', '130435194503097019', 78);
INSERT INTO `health_personnel` VALUES ('w1159', 'j2', '潘祺余', '副高', '女', '140724196706077198', 56);
INSERT INTO `health_personnel` VALUES ('w1160', 'j2', '史畅秀', '副高', '男', '420525200003082400', 23);
INSERT INTO `health_personnel` VALUES ('w1161', 'j2', '郦琼赢', '医生', '女', '530621200004093836', 23);
INSERT INTO `health_personnel` VALUES ('w1162', 'j2', '林唯诗', '正高', '男', '37078219951003847X', 27);
INSERT INTO `health_personnel` VALUES ('w1163', 'j2', '严章郁', '精英', '女', '469006191107046129', 112);
INSERT INTO `health_personnel` VALUES ('w1164', 'j2', '缪蝶蝶', '副高', '男', '231124196409200946', 58);
INSERT INTO `health_personnel` VALUES ('w1165', 'j3', '陆严澎', '医生', '男', '421123197207139570', 51);
INSERT INTO `health_personnel` VALUES ('w1166', 'j3', '冯渝莹', '医生', '男', '130632199907014456', 24);
INSERT INTO `health_personnel` VALUES ('w1167', 'j3', '张垚远', '医生', '女', '23122420210120897X', 2);
INSERT INTO `health_personnel` VALUES ('w1168', 'j3', '侯琼炯', '医生', '男', '150121193908090856', 84);
INSERT INTO `health_personnel` VALUES ('w1169', 'j3', '平铃舟', '副高', '女', '511827193105091649', 92);
INSERT INTO `health_personnel` VALUES ('w1170', 'j3', '支钊淮', '副高', '男', '330902196404226758', 59);
INSERT INTO `health_personnel` VALUES ('w1171', 'j4', '龙育冕', '医生', '女', '445303197202160250', 51);
INSERT INTO `health_personnel` VALUES ('w1172', 'j4', '陈淳翔', '副高', '男', '140405197702152284', 46);
INSERT INTO `health_personnel` VALUES ('w1173', 'j4', '宫克红', '正高', '女', '520330202011128467', 2);
INSERT INTO `health_personnel` VALUES ('w1174', 'j4', '郁娜芬', '精英', '男', '450981196603140845', 57);
INSERT INTO `health_personnel` VALUES ('w1175', 'j4', '沈暖妹', '医生', '女', '131121200702162359', 16);
INSERT INTO `health_personnel` VALUES ('w1176', 'j4', '苏洋胡', '医生', '男', '230382198705278492', 36);
INSERT INTO `health_personnel` VALUES ('w1177', 'j5', '惠臣柱', '医生', '女', '510623194802194675', 75);
INSERT INTO `health_personnel` VALUES ('w1178', 'j5', '谢蔷琪', '医生', '男', '150102200708289354', 15);
INSERT INTO `health_personnel` VALUES ('w1179', 'j5', '明钥韵', '副高', '男', '430723193601041075', 87);
INSERT INTO `health_personnel` VALUES ('w1180', 'j5', '周芳晨', '副高', '女', '540122191008232417', 112);
INSERT INTO `health_personnel` VALUES ('w1181', 'j5', '谭硕舟', '医生', '男', '610324201302117776', 10);
INSERT INTO `health_personnel` VALUES ('w1182', 'j5', '毛琳甜', '正高', '女', '37021519380428839X', 85);
INSERT INTO `health_personnel` VALUES ('w1183', 'j5', '幸振忆', '精英', '男', '44152120070515368X', 16);
INSERT INTO `health_personnel` VALUES ('w1184', 'j5', '夏建飚', '精英', '女', '371083190407074454', 119);
INSERT INTO `health_personnel` VALUES ('w1185', 'j6', '鲁妃星', '精英', '男', '410181190311277227', 119);
INSERT INTO `health_personnel` VALUES ('w1186', 'j6', '甄煦可', '副高', '女', '42032519770707477X', 46);
INSERT INTO `health_personnel` VALUES ('w1187', 'j6', '袁沙楚', '医生', '男', '610327201509079040', 7);
INSERT INTO `health_personnel` VALUES ('w1188', 'j6', '龙霆韬', '副高', '女', '320921197407219846', 49);
INSERT INTO `health_personnel` VALUES ('w1189', 'j6', '叶友勋', '正高', '男', '513327196302189563', 60);
INSERT INTO `health_personnel` VALUES ('w1190', 'j6', '咎研亚', '精英', '女', '140927193011290992', 92);
INSERT INTO `health_personnel` VALUES ('w1191', 'j6', '韶绚樱', '医生', '男', '130204192602280965', 97);
INSERT INTO `health_personnel` VALUES ('w1192', 'q1', '韩艾心', '医生', '女', '360724195710158675', 65);
INSERT INTO `health_personnel` VALUES ('w1193', 'j7', '黎卉晔', '副高', '男', '130105200203239867', 21);
INSERT INTO `health_personnel` VALUES ('w1194', 'j7', '伊屹盼', '正高', '男', '210904200503192148', 18);
INSERT INTO `health_personnel` VALUES ('w1195', 'j7', '潘蔷芬', '精英', '女', '422828196312237857', 59);
INSERT INTO `health_personnel` VALUES ('w1196', 'j7', '金花言', '医生', '男', '320681192802080829', 95);
INSERT INTO `health_personnel` VALUES ('w1197', 'q1', '邱纯默', '医生', '女', '430529190410211821', 118);
INSERT INTO `health_personnel` VALUES ('w1198', 'q1', '张嫒晓', '医生', '男', '46902719251231068X', 97);
INSERT INTO `health_personnel` VALUES ('w1199', 'q1', '杨羽旋', '医生', '男', '50023819170806015X', 106);
INSERT INTO `health_personnel` VALUES ('w1200', 'g2', '咎奕咪', '副高', '女', '150207194010126675', 82);
INSERT INTO `health_personnel` VALUES ('w1201', 'g2', '鲍璇朗', '副高', '男', '451003193505086282', 88);
INSERT INTO `health_personnel` VALUES ('w1202', 'n1', '姚懿青', '医生', '女', '231281197107116383', 52);
INSERT INTO `health_personnel` VALUES ('w1203', 'n1', '苏娓蓉', '正高', '男', '42052719790112085X', 44);
INSERT INTO `health_personnel` VALUES ('w1204', 'n1', '蔡衡方', '精英', '男', '511129194010202552', 82);
INSERT INTO `health_personnel` VALUES ('w1205', 'n2', '怀含颜', '副高', '男', '511126195708042031', 66);
INSERT INTO `health_personnel` VALUES ('w1206', 'n2', '秋正锁', '医生', '女', '360402193503123484', 88);
INSERT INTO `health_personnel` VALUES ('w1207', 'n2', '虞怡芮', '医生', '男', '440507196707086460', 56);
INSERT INTO `health_personnel` VALUES ('w1208', 'w3', '程笛奇', '医生', '女', '210104198712272482', 35);
INSERT INTO `health_personnel` VALUES ('w1209', 'w3', '殷舟钊', '医生', '男', '350982192101309692', 102);
INSERT INTO `health_personnel` VALUES ('w1210', 'w3', '黄钧瑛', '副高', '女', '210882190801310955', 115);
INSERT INTO `health_personnel` VALUES ('w1211', 'w3', '殷鸿韵', '副高', '男', '513435199201011159', 31);
INSERT INTO `health_personnel` VALUES ('w1212', 'w7', '范钰侃', '医生', '女', '511112199608099858', 27);
INSERT INTO `health_personnel` VALUES ('w1213', 'w7', '薛义年', '副高', '男', '530927201006010108', 13);
INSERT INTO `health_personnel` VALUES ('w1214', 'w7', '殷咏日', '正高', '女', '451122197103083065', 52);
INSERT INTO `health_personnel` VALUES ('w1215', 'y1', '邴好歆', '精英', '男', '211281199602231069', 27);
INSERT INTO `health_personnel` VALUES ('w1216', 'y1', '凤乾月', '医生', '女', '530303194001029903', 83);
INSERT INTO `health_personnel` VALUES ('w1217', 'y1', '毛林或', '医生', '男', '371103196504211570', 58);
INSERT INTO `health_personnel` VALUES ('w1218', 'y1', '成璐秀', '医生', '男', '210402198910212644', 33);
INSERT INTO `health_personnel` VALUES ('w1219', 'k1', '庞菲芊', '医生', '女', '650521200502190497', 18);
INSERT INTO `health_personnel` VALUES ('w1220', 'k1', '卓研浩', '副高', '男', '440118199712094335', 25);
INSERT INTO `health_personnel` VALUES ('w1221', 'k1', '姬昆佳', '医生', '女', '420607190401072482', 119);
INSERT INTO `health_personnel` VALUES ('w1222', 'k1', '莫珊辰', '医生', '男', '330305195402057104', 69);

-- ----------------------------
-- Table structure for medical_histories
-- ----------------------------
DROP TABLE IF EXISTS `medical_histories`;
CREATE TABLE `medical_histories`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '既往史',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `condition_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `diagnosis_date` date NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `from_patientid`(`patient_id` ASC) USING BTREE,
  CONSTRAINT `hisfrom_patientid` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medical_histories
-- ----------------------------
INSERT INTO `medical_histories` VALUES (1, '123123123412341234', '糖尿病', '2025-02-06', 'string');

-- ----------------------------
-- Table structure for medical_record
-- ----------------------------
DROP TABLE IF EXISTS `medical_record`;
CREATE TABLE `medical_record`  (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '门诊病历，已剔除check',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门诊医师',
  `dno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `hospital` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '初诊/复诊/急诊',
  `companion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否有陪护',
  `chief_complaint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '主诉',
  `present_illness` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '现病史',
  `timestamp` datetime NULL DEFAULT NULL,
  `temperature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '体温 ℃',
  `pulse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '脉搏 （次/分）',
  `sbp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收缩压 mmHg',
  `dbp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '舒张压 mmHg',
  `pulmonary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '呼吸 （次/分）',
  `consciousness` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '意识状态',
  `measures` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理措施',
  `observation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否留观',
  `assessment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '初步评估结果/诊断',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `from_patientid`(`patient_id` ASC) USING BTREE,
  INDEX `from_wid`(`wid` ASC) USING BTREE,
  INDEX `med_department`(`dno` ASC) USING BTREE,
  CONSTRAINT `med_department` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `med_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `med_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10031 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medical_record
-- ----------------------------
INSERT INTO `medical_record` VALUES (10010, '123123123412341234', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '零号病历');
INSERT INTO `medical_record` VALUES (10025, '123123123412341234', 'w10001', 'b1', 'string', 'string', 'string', 'string', 'string', '2025-02-06 06:23:14', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', '别管了，玩一下智能手机');
INSERT INTO `medical_record` VALUES (10027, '123123123412341234', 'w10001', 'b1', 'string', 'string', 'string', 'string', 'string', '2025-02-06 07:22:00', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string');
INSERT INTO `medical_record` VALUES (10028, '123123123412341234', 'w10001', 'b1', 'string', 'string', 'string', 'string', 'string', '2025-02-07 10:07:07', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string');
INSERT INTO `medical_record` VALUES (10029, '123123123412341234', 'd5205', 'f2', '人民医院', '门诊', '无', '腹痛', '无', '2025-02-19 10:59:03', '36.5', NULL, NULL, NULL, NULL, '清醒', '阿奇霉素一日三顿，每天睡觉，不要上班', '无', '上班上的', NULL);
INSERT INTO `medical_record` VALUES (10030, '123123200308281234', 'd5206', 'g1', 'xx市第二人民医院', '急诊', '有', '右足外伤2h。', '患者自述右足外伤2h。否认其他外伤。', '2025-02-19 11:45:29', '36.5', '无', '无', '无', '无', '清醒', '足.正斜位（DR），PET拍片，手足外科会诊', '否', '右足骰骨外侧缘撕脱骨折可能，下肢损伤', NULL);

-- ----------------------------
-- Table structure for medicine
-- ----------------------------
DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine`  (
  `mid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `mname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `factory` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `store` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `specs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sell` int UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`mid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medicine
-- ----------------------------
INSERT INTO `medicine` VALUES ('m13802', '阿奇霉素片', '薄膜衣片', '汕头金石制药总厂有限公司', 18.10, '盒', '100', '0.5g*6片', 10);
INSERT INTO `medicine` VALUES ('m13803', '氨麻美敏片(Ⅱ)', '薄膜衣片', '中美天津史克制药有限公司', 18.80, '盒', '100', '20片', 11);
INSERT INTO `medicine` VALUES ('m13804', '比卡鲁胺片', '薄膜衣片', '浙江海正药业股份有限公司', 750.00, '盒', '97', '50mg*20片', 16);
INSERT INTO `medicine` VALUES ('m13805', '吡格列酮片', '薄膜衣片', '江苏德源药业股份有限公司', 57.00, '盒', '100', '30mg*14s', 12);
INSERT INTO `medicine` VALUES ('m13806', '雌二醇片/雌二醇地屈孕酮片复合包装', '薄膜衣片', 'Abbott Biologicals B.V.', 115.00, '盒', '81', '28片', 33);
INSERT INTO `medicine` VALUES ('m13807', '雌二醇屈螺酮片', '薄膜衣片', '德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)', 268.00, '盒', '100', '28片', 3);
INSERT INTO `medicine` VALUES ('m13808', '茜芷片', '薄膜衣片', '甘肃兰药药业有限公司', 81.70, '盒', '100', '0.4g*45片', 4);
INSERT INTO `medicine` VALUES ('m13809', '童康片', '薄膜衣片', '广州康和药业有限公司', 37.80, '盒', '100', '0.2g*60片', 5);
INSERT INTO `medicine` VALUES ('m13810', '血府逐瘀片', '薄膜衣片', '陕西海天制药有限公司', 38.50, '盒', '100', '0.42g*48片', 2);
INSERT INTO `medicine` VALUES ('m13811', '缩宫素鼻喷雾剂', '鼻喷雾剂', '四川美科制药有限公司', 52.20, '瓶', '100', '200U:5ml', 22);
INSERT INTO `medicine` VALUES ('m13812', '枯草杆菌二联活菌肠溶胶囊', '肠溶胶囊', '北京韩美药品有限公司', 26.80, '盒', '100', '0.25g*20粒 ', 5);
INSERT INTO `medicine` VALUES ('m13813', '雷贝拉唑钠肠溶胶囊(大)', '肠溶胶囊', '济川药业集团有限公司', 62.10, '盒', '100', '20mg*7粒', 2);
INSERT INTO `medicine` VALUES ('m13814', '雷贝拉唑钠肠溶胶囊(小)', '肠溶胶囊', '珠海润都制药股份有限公司', 37.20, '盒', '100', '10mg*7粒', 3);
INSERT INTO `medicine` VALUES ('m13815', '脉血康胶囊', '肠溶胶囊', '贵州信邦制药股份有限公司', 39.90, '盒', '100', '0.25g*36粒', 12);
INSERT INTO `medicine` VALUES ('m13816', '阿司匹林肠溶片(J)', '肠溶片', '意大利 Bayer HealthCare Manufacturing S.r.l.(拜耳医药保健有限公司分装)', 16.10, '盒', '100', '0.1g*30片', 4);
INSERT INTO `medicine` VALUES ('m13817', '地红霉素肠溶片', '肠溶片', '浙江金华康恩贝生物制药有限公司', 31.20, '盒', '100', '0.125g*8片', 2);
INSERT INTO `medicine` VALUES ('m13818', '二甲双胍肠溶片（国）', '肠溶片', '贵州圣济堂制药有限公司', 13.80, '盒', '100', '0.5g*60片', 4);
INSERT INTO `medicine` VALUES ('m13819', '复方阿嗪米特肠溶片', '肠溶片', '扬州一洋制药有限公司', 36.10, '盒', '100', '75mg*20片', 12);
INSERT INTO `medicine` VALUES ('m13820', '兰索拉唑肠溶片', '肠溶片', '扬子江药业集团四川海蓉药业有限公司', 28.20, '盒', '100', '15mg*14片', 42);
INSERT INTO `medicine` VALUES ('m13821', '消栓肠溶胶囊', '肠溶微丸胶囊', '三门峡赛诺维制药有限公司', 50.70, '盒', '100', '0.2g*24粒', 12);
INSERT INTO `medicine` VALUES ('m13822', '安脑丸', '大蜜丸', '哈尔滨蒲公英药业有限公司', 62.00, '盒', '100', '3g*6丸', 1);
INSERT INTO `medicine` VALUES ('m13823', '前列舒丸', '大蜜丸', '威海人生药业集团股份有限公司', 37.00, '盒', '100', '9g*10丸', 12);
INSERT INTO `medicine` VALUES ('m13824', '左氧氟沙星滴耳液', '滴耳剂', '深圳万和制药有限公司', 26.10, '盒', '100', '25mg:5ml', 23);
INSERT INTO `medicine` VALUES ('m13825', '复方丹参滴丸', '滴丸', '天士力制药集团股份有限公司', 28.80, '盒', '100', '27mg*180粒', 12);
INSERT INTO `medicine` VALUES ('m13826', '宫炎平滴丸', '滴丸', '广东罗浮山国药股份有限公司', 48.30, '盒', '100', '50mg*240粒', 1);
INSERT INTO `medicine` VALUES ('m13827', '0.1%氟米龙滴眼剂', '滴眼剂', 'Allergan Pharmaceuticals Ireland', 21.90, '支', '100', '5mg:5ml', 2);
INSERT INTO `medicine` VALUES ('m13828', '0.5%羧甲基纤维素钠滴眼剂', '滴眼剂', 'Allergan Pharmaceuticals Ireland', 58.60, '盒', '100', '0.4ml*30支', 3);
INSERT INTO `medicine` VALUES ('m13829', '奥洛他定滴眼剂', '滴眼剂', 'Alcon laboratories (UK) Ltd', 112.00, '支', '100', '5ml', 12);
INSERT INTO `medicine` VALUES ('m13830', '贝美前列素滴眼剂', '滴眼剂', 'Allergan Sales LLC', 173.00, '支', '100', '0.9mg:3ml', 1);
INSERT INTO `medicine` VALUES ('m13831', '倍他洛尔滴眼剂', '滴眼剂', 's.a.ALCON-COUVREUR n.v.', 48.30, '支', '100', '12.5mg:5ml', 23);
INSERT INTO `medicine` VALUES ('m13832', '吡诺克辛滴眼剂', '滴眼剂', '参天制药株式会社能登工厂', 14.40, '支', '100', '0.25mg:5ml', 12);
INSERT INTO `medicine` VALUES ('m13833', '冰珍清目滴眼剂', '滴眼剂', '湖北远大天天明制药有限公司', 22.50, '盒', '97', '5ml*2支', 4);
INSERT INTO `medicine` VALUES ('m13834', '冰珍去翳滴眼剂', '滴眼剂', '湖北远大天天明制药有限公司', 16.30, '支', '100', '10ml', 2);
INSERT INTO `medicine` VALUES ('m13835', '丙美卡因滴眼剂', '滴眼剂', 's.a.ALCON-COUVREUR n.v.', 40.30, '支', '100', '75mg:15ml', 3);
INSERT INTO `medicine` VALUES ('m13836', '玻璃酸钠滴眼剂(J)', '滴眼剂', '参天制药株式会社能登工厂', 30.00, '支', '100', '5mg:5ml', 1);
INSERT INTO `medicine` VALUES ('m13837', '玻璃酸钠滴眼剂(国)', '滴眼剂', '珠海联邦制药股份有限公司', 25.80, '支', '100', '5mg:5ml', 2);
INSERT INTO `medicine` VALUES ('m13838', '布林佐胺滴眼剂', '滴眼剂', 'Alcon Laboratories(UK) Ltd.', 82.80, '支', '100', '50mg:5ml', 3);
INSERT INTO `medicine` VALUES ('m13839', '非尼拉敏萘甲唑啉滴眼剂', '滴眼剂', 's.a.ALCON-COUVREUR n.v.', 20.70, '支', '100', '15ml', 2);
INSERT INTO `medicine` VALUES ('m13840', '复方右旋糖酐70滴眼液', '滴眼剂', '江西禾氏美康药业有限公司', 29.50, '支', '100', '15mg:15ml', 3);
INSERT INTO `medicine` VALUES ('m13841', '复方右旋糖酐70滴眼液', '滴眼剂', '安徽省双科药业有限公司', 29.70, '支', '100', '15mg:15ml', 2);
INSERT INTO `medicine` VALUES ('m13842', '更昔洛韦滴眼剂', '滴眼剂', '湖北远大天天明制药有限公司', 20.90, '支', '100', '8mg:8ml', 3);
INSERT INTO `medicine` VALUES ('m13843', '加替沙星滴眼剂', '滴眼剂', '安徽省双科药业有限公司', 20.60, '支', '99', '15mg:5ml', 3);
INSERT INTO `medicine` VALUES ('m13844', '加替沙星滴眼剂（大）', '滴眼剂', '楚雄老拨云堂药业有限公司', 30.50, '支', '100', '24mg:8ml', 3);
INSERT INTO `medicine` VALUES ('m13845', '聚乙二醇滴眼液', '滴眼剂', 'Alcon Laboratories,Inc', 40.50, '支', '100', '5ml', 1);
INSERT INTO `medicine` VALUES ('m13846', '聚乙烯醇滴眼剂(J)', '滴眼剂', 'Taiwan Biotech Co.Ltd', 38.70, '盒', '100', '0.5ml*10支', 2);
INSERT INTO `medicine` VALUES ('m13847', '聚乙烯醇滴眼液(国)', '滴眼剂', '湖北远大天天明制药有限公司', 28.40, '盒', '100', '0.8ml*15支', 2);
INSERT INTO `medicine` VALUES ('m13848', '卡波姆滴眼剂', '滴眼剂', 'Dr.Gerhard Mann. Chem.-Pharm. Fabrik Gmbh', 29.70, '支', '100', '20mg:10g', 3);
INSERT INTO `medicine` VALUES ('m13849', '卡替洛尔滴眼剂', '滴眼剂', '中国大冢制药有限公司', 25.80, '支', '100', '5ml', 2);
INSERT INTO `medicine` VALUES ('m13850', '拉坦前列素滴眼剂', '滴眼剂', 'PFIZER SA', 218.00, '支', '100', '125ug：2.5ml', 1);
INSERT INTO `medicine` VALUES ('m13851', '拉坦前列素滴眼液', '滴眼剂', '华润紫竹药业有限公司', 158.00, '支', '100', '125ug：2.5ml', 1);
INSERT INTO `medicine` VALUES ('m13852', '氯替泼诺滴眼剂', '滴眼剂', 'Bausch&Lomb Incorporated', 86.00, '支', '100', '25mg：5ml', 1);
INSERT INTO `medicine` VALUES ('m13853', '泼尼松龙滴眼剂', '滴眼剂', 'Allergan Pharmaceuticals Ireland', 35.20, '支', '100', '50mg:5ml', 1);
INSERT INTO `medicine` VALUES ('m13854', '普拉洛芬滴眼剂（J）', '滴眼剂', '千寿制药株式会社', 44.30, '支', '100', '5mg:5ml', 1);
INSERT INTO `medicine` VALUES ('m13855', '普拉洛芬滴眼液（国）', '滴眼剂', '山东海山药业有限公司', 41.30, '支', '98', '5mg:5ml', 3);
INSERT INTO `medicine` VALUES ('m13856', '七叶洋地黄双苷滴眼剂', '滴眼剂', 'Pharma Stulln GmbH 德国视都灵药品有限责任公司', 41.00, '盒', '100', '0.4ml*10支', 0);
INSERT INTO `medicine` VALUES ('m13857', '曲伏前列素滴眼剂', '滴眼剂', 'ALCON Cusi, S.A.', 225.00, '支', '100', '0.1mg:2.5ml', 1);
INSERT INTO `medicine` VALUES ('m13858', '双氯芬酸钠滴眼剂', '滴眼剂', '沈阳兴齐眼药股份有限公司', 14.30, '支', '100', '5mg:5ml', 1);
INSERT INTO `medicine` VALUES ('m13859', '双氯芬酸钠滴眼剂', '滴眼剂', '沈阳兴齐眼药股份有限公司', 21.00, '盒', '100', '1mg:1ml*5支', 0);
INSERT INTO `medicine` VALUES ('m13860', '妥布霉素滴眼剂', '滴眼剂', 's.a.ALCON-COUVREUR n.v.', 18.60, '支', '100', '15mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m13861', '妥布霉素地塞米松滴眼剂(J)', '滴眼剂', 's.a.ALCON-COUVREUR n.v.', 37.00, '支', '100', '20mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m13862', '溴莫尼定滴眼剂', '滴眼剂', 'Allergan Pharmaceuticals Ireland', 81.10, '支', '100', '10mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m13863', '眼氨肽滴眼剂', '滴眼剂', '陕西博森生物制药股份集团有限公司', 21.30, '支', '100', '25g:10ml', 0);
INSERT INTO `medicine` VALUES ('m13864', '氧氟沙星滴眼剂(J)', '滴眼剂', '参天制药株式会社能登工厂', 22.00, '支', '100', '15mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m13865', '依美斯汀滴眼剂', '滴眼剂', 'Alcon laboratories (UK) Ltd', 38.50, '支', '100', '2.5mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m13866', '重组牛碱性成纤维细胞生长因子滴眼剂', '滴眼剂', '珠海亿胜生物制药有限公司', 27.60, '支', '100', '21000IU:5ml', 0);
INSERT INTO `medicine` VALUES ('m13867', '重组人表皮生长因子衍生物滴眼剂', '滴眼剂', '深圳市华生元基因工程发展有限公司', 31.50, '支', '100', '15000u:3ml', 0);
INSERT INTO `medicine` VALUES ('m13868', '重组人干扰素a2b滴眼液', '滴眼剂', '安徽安科生物工程(集团)股份有限公司', 24.10, '支', '100', '100万IU:5ml', 0);
INSERT INTO `medicine` VALUES ('m13869', '左氧氟沙星滴眼剂(J)', '滴眼剂', '参天制药株式会社能登工厂', 35.60, '支', '100', '5ml', 0);
INSERT INTO `medicine` VALUES ('m13870', '左氧氟沙星滴眼剂(国)', '滴眼剂', '山东博士伦福瑞达制药有限公司', 12.10, '支', '100', '15mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m13871', '复方熊胆滴眼液', '滴眼液', '长春普华制药股份有限公司', 29.70, '支', '100', '12ml', 0);
INSERT INTO `medicine` VALUES ('m13872', '金珍滴眼液', '滴眼液', '安徽省双科药业有限公司', 36.20, '支', '100', '8ml', 0);
INSERT INTO `medicine` VALUES ('m13873', '近视乐滴眼液', '滴眼液', '长春普华制药股份有限公司', 47.50, '支', '100', '8ml', 0);
INSERT INTO `medicine` VALUES ('m13874', '麝珠明目滴眼液', '滴眼液', '福建麝珠明眼药股份有限公司', 36.70, '支', '100', '300mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m13875', '镇痛活络酊', '酊剂', '上海景峰制药有限公司', 44.90, '瓶', '100', '50ml', 0);
INSERT INTO `medicine` VALUES ('m13876', '外用重组人碱性成纤维细胞生长因子', '冻干粉剂', '南海朗肽制药有限公司', 68.70, '支', '100', '20000IU', 0);
INSERT INTO `medicine` VALUES ('m13877', '阿莫西林克拉维酸钾分散片', '分散片', '南京臣功制药股份有限公司', 23.60, '盒', '100', '0.457g*8片', 0);
INSERT INTO `medicine` VALUES ('m13878', '氯雷他定分散片', '分散片', '北京双鹭药业股份有限公司', 25.50, '盒', '100', '10mg*10片', 0);
INSERT INTO `medicine` VALUES ('m13879', '阿莫西林克拉维酸钾干混悬剂', '干混悬剂', '上海海虹实业（集团）巢湖今辰药业有限公司', 27.40, '盒', '100', '0.643g*6袋', 0);
INSERT INTO `medicine` VALUES ('m13880', '阿奇霉素干混悬剂', '干混悬剂', '辉瑞制药有限公司', 43.60, '盒', '100', '0.1g*6袋', 0);
INSERT INTO `medicine` VALUES ('m13881', '丹莪妇康煎膏', '膏剂', '滇虹药业集团股份有限公司', 56.30, '瓶', '100', '150g', 0);
INSERT INTO `medicine` VALUES ('m13882', '多磺酸粘多糖软膏', '膏剂', 'obilat Produktions GmbH', 31.50, '支', '100', '14g', 20);
INSERT INTO `medicine` VALUES ('m13883', '肤舒止痒膏', '膏剂', '贵州科福丽康制药有限公司', 27.60, '支', '100', '100g', 12);
INSERT INTO `medicine` VALUES ('m13884', '复方角菜酸酯乳膏', '膏剂', '西安杨森制药有限公司', 33.60, '支', '100', '20g', 2);
INSERT INTO `medicine` VALUES ('m13885', '精制狗皮膏', '膏剂', '黄石卫生材料药业有限公司', 15.90, '盒', '100', '7cm×10cm*6贴', 13);
INSERT INTO `medicine` VALUES ('m13886', '膦甲酸钠乳膏', '膏剂', '上海现代制药股份有限公司', 16.70, '支', '100', '5g:0.15g', 1);
INSERT INTO `medicine` VALUES ('m13887', '玫芦消痤膏', '膏剂', '佳程药业（贵州）有限责任公司', 23.50, '支', '100', '30g', 1);
INSERT INTO `medicine` VALUES ('m13888', '咪康唑乳膏', '膏剂', '西安杨森制药有限公司', 14.50, '支', '100', '20g', 2);
INSERT INTO `medicine` VALUES ('m13889', '莫米松乳膏', '膏剂', '上海通用药业股份有限公司', 12.30, '支', '100', '5mg', 0);
INSERT INTO `medicine` VALUES ('m13890', '莫匹罗星乳膏', '膏剂', '中美天津史克制药有限公司', 14.00, '支', '100', '5g', 12);
INSERT INTO `medicine` VALUES ('m13891', '曲安奈德益康唑乳膏', '膏剂', '西安杨森制药有限公司', 18.90, '支', '100', '15g', 2);
INSERT INTO `medicine` VALUES ('m13892', '润肌皮肤膏', '膏剂', '广西金海堂药业有限责任公司', 54.80, '盒', '100', '10g', 0);
INSERT INTO `medicine` VALUES ('m13893', '湿润烧伤膏', '膏剂', '汕头市美宝制药有限公司', 25.00, '支', '100', '40g', 0);
INSERT INTO `medicine` VALUES ('m13894', '双氯芬酸钠二乙胺乳膏', '膏剂', '北京诺华制药有限公司', 22.90, '支', '100', '20g:0.2g', 0);
INSERT INTO `medicine` VALUES ('m13895', '复方阿胶浆', '合计', '山东东阿阿胶股份有限公司', 38.40, '盒', '100', '20ml*12支', 0);
INSERT INTO `medicine` VALUES ('m13896', '长春胺缓释胶囊', '缓释胶囊', '烟台鲁银药业有限公司', 63.60, '盒', '100', '30mg*12粒', 0);
INSERT INTO `medicine` VALUES ('m13897', '单硝酸异山梨酯缓释胶囊', '缓释胶囊', '珠海许瓦兹制药有限公司', 39.10, '盒', '100', '50mg*10粒', 0);
INSERT INTO `medicine` VALUES ('m13898', '坦洛新缓释胶囊', '缓释胶囊', '浙江海力生制药有限公司', 77.00, '盒', '100', '0.2mg*10粒', 0);
INSERT INTO `medicine` VALUES ('m13899', '坦索罗辛缓释胶囊', '缓释胶囊', '安斯泰来制药(中国)有限公司', 67.90, '盒', '100', '0.2mg*10粒', 0);
INSERT INTO `medicine` VALUES ('m13900', '头孢克洛缓释胶囊', '缓释胶囊', '扬子江药业集团有限公司', 25.50, '盒', '100', '125mg*12粒', 22);
INSERT INTO `medicine` VALUES ('m13901', '非洛地平缓释片', '缓释片', '阿斯利康制药有限公司', 38.00, '盒', '99', '5mg*10片', 3);
INSERT INTO `medicine` VALUES ('m13902', '格列齐特缓释片', '缓释片', '施维雅(天津)制药有限公司', 56.60, '盒', '100', '30mg*30片', 1);
INSERT INTO `medicine` VALUES ('m13903', '克拉霉素缓释片', '缓释片', '江苏恒瑞医药股份有限公司', 21.40, '盒', '100', '0.5g*3片', 12);
INSERT INTO `medicine` VALUES ('m13904', '乌拉地尔缓释片', '缓释片', '西安利君制药有限责任公司', 22.90, '盒', '100', '30mg*20片', 0);
INSERT INTO `medicine` VALUES ('m13905', '硝苯地平缓释片', '缓释片', '浙江昂利康制药有限公司', 11.10, '盒', '100', '10mg*48片', 12);
INSERT INTO `medicine` VALUES ('m13906', '多潘立酮混悬液', '混悬剂', 'JK西安杨森制药有限公司', 14.50, '瓶', '100', '100ml', 0);
INSERT INTO `medicine` VALUES ('m13907', '铝镁加混悬液', '混悬剂', '扬州一洋制药有限公司', 30.90, '盒', '100', '1.5g:15ml*12袋', 0);
INSERT INTO `medicine` VALUES ('m13908', '阿法骨化醇软胶囊(J）', '胶囊', 'Tev Pharmaceutical Industries Ltd.', 78.20, '盒', '100', '1ug*10粒', 0);
INSERT INTO `medicine` VALUES ('m13909', '阿法骨化醇软胶囊（国）', '胶囊', '南通华山药业有限公司', 34.50, '盒', '100', '0.25ug*30粒', 12);
INSERT INTO `medicine` VALUES ('m13910', '阿莫西林胶囊', '胶囊', '昆明贝克诺顿制药有限公司', 11.00, '盒', '100', '250mg*20粒', 12);
INSERT INTO `medicine` VALUES ('m13911', '百乐眠胶囊', '胶囊', '扬子江药业集团有限公司', 37.90, '盒', '100', '270mg*24粒', 1);
INSERT INTO `medicine` VALUES ('m13912', '百令胶囊', '胶囊', '杭州中美华东制药有限公司', 74.90, '盒', '100', '0.5g*42s', 0);
INSERT INTO `medicine` VALUES ('m13913', '胞磷胆碱钠胶囊', '胶囊', '齐鲁制药有限公司', 45.70, '盒', '100', '0.1g*24粒', 2);
INSERT INTO `medicine` VALUES ('m13914', '标准桃金娘油肠溶胶囊', '胶囊', '德国保时佳大药厂', 24.40, '盒', '100', '300mg*10粒', 0);
INSERT INTO `medicine` VALUES ('m13915', '布洛芬缓释胶囊', '胶囊', '中美天津史克制药有限公司', 14.80, '盒', '94', '0.3g*20粒', 6);
INSERT INTO `medicine` VALUES ('m13916', '参松养心胶囊', '胶囊', '北京以岭药业有限公司', 29.90, '盒', '100', '400mg*36粒', 12);
INSERT INTO `medicine` VALUES ('m13917', '地尔硫卓缓释胶囊', '胶囊', '天津田边制药有限公司', 20.90, '盒', '100', '90mg*10粒', 0);
INSERT INTO `medicine` VALUES ('m13918', '多烯磷脂酰胆碱胶囊', '胶囊', '赛诺菲（北京）制药有限公司', 49.10, '盒', '100', '228mg*24粒', 0);
INSERT INTO `medicine` VALUES ('m13919', '氟桂利嗪胶囊', '胶囊', 'JK西安杨森制药有限公司', 27.20, '盒', '100', '5mg*20粒', 0);
INSERT INTO `medicine` VALUES ('m13920', '妇科千金胶囊', '胶囊', '株洲千金药业股份有限公司', 26.70, '盒', '100', '0.4g*24粒', 0);
INSERT INTO `medicine` VALUES ('m13921', '妇科养荣胶囊', '胶囊', '西安阿房宫药业股份有限公司', 34.50, '盒', '100', '0.35g*36粒', 0);
INSERT INTO `medicine` VALUES ('m13922', '妇炎舒胶囊', '胶囊', '陕西东科制药有限责任公司', 27.50, '盒', '100', '0.4g*48粒', 0);
INSERT INTO `medicine` VALUES ('m13923', '妇月康胶囊', '胶囊', '陕西东泰制药有限公司', 30.90, '盒', '100', '600mg*48粒', 0);
INSERT INTO `medicine` VALUES ('m13924', '复方乌鸡胶囊', '胶囊', '江西天施康中药股份有限公司', 21.40, '盒', '100', '0.25g*20粒', 0);
INSERT INTO `medicine` VALUES ('m13925', '复方血栓通胶囊', '胶囊', '广东众生药业股份有限公司', 26.00, '盒', '100', '0.5g*30粒', 0);
INSERT INTO `medicine` VALUES ('m13926', '复方益母胶囊', '胶囊', '翔宇药业股份有限公司', 33.10, '盒', '100', '0.42g*45粒', 0);
INSERT INTO `medicine` VALUES ('m13927', '复方珍珠暗疮胶囊', '胶囊', '清华德人西安幸福制药有限公司', 45.30, '盒', '100', '0.3g*72粒 ', 0);
INSERT INTO `medicine` VALUES ('m13928', '宫瘤宁胶囊', '胶囊', '康县独一味生物制药有限公司', 46.60, '盒', '100', '0.3g*54粒', 0);
INSERT INTO `medicine` VALUES ('m13929', '宫炎平胶囊', '胶囊', '江西民济药业有限公司', 27.40, '盒', '100', '0.25g*48粒', 0);
INSERT INTO `medicine` VALUES ('m13930', '骨愈灵胶囊', '胶囊', '陕西威信制药有限公司', 62.80, '盒', '100', '400mg*60粒', 0);
INSERT INTO `medicine` VALUES ('m13931', '红花逍遥胶囊', '胶囊', '云南楚雄天利药业有限公司', 37.40, '盒', '100', '0.4g*24粒', 0);
INSERT INTO `medicine` VALUES ('m13932', '黄葵胶囊', '胶囊', '江苏苏中药业集团股份有限公司', 34.50, '盒', '100', '0.5g*30粒', 0);
INSERT INTO `medicine` VALUES ('m13933', '黄体酮胶囊', '胶囊', '浙江仙琚制药股份有限公司', 35.70, '盒', '100', '50mg*20粒', 0);
INSERT INTO `medicine` VALUES ('m13934', '活血止痛胶囊', '胶囊', '江西百神昌诺药业有限公司', 43.40, '盒', '100', '0.5g*48粒', 0);
INSERT INTO `medicine` VALUES ('m13935', '甲钴铵胶囊', '胶囊', '扬子江药业集团南京海陵药业有限公司', 52.60, '盒', '100', '0.5mg*50粒', 0);
INSERT INTO `medicine` VALUES ('m13936', '金嗓利咽胶囊', '胶囊', '西安碑林药业股份有限公司', 29.50, '盒', '100', '0.4g*12粒', 0);
INSERT INTO `medicine` VALUES ('m13937', '金水宝胶囊', '胶囊', '江西济民可信金水宝制药有限公司', 43.20, '盒', '100', '330mg*63粒', 0);
INSERT INTO `medicine` VALUES ('m13938', '抗妇炎胶囊', '胶囊', '贵州远程制药有限责任公司', 28.70, '盒', '100', '0.35g*36粒', 0);
INSERT INTO `medicine` VALUES ('m13939', '六锐胶囊', '胶囊', '西安大唐制药集团有限公司', 61.50, '盒', '100', '0.25g*12粒', 0);
INSERT INTO `medicine` VALUES ('m13940', '六味安消胶囊', '胶囊', '贵州信邦制药股份有限公司', 23.30, '盒', '100', '500mg*36粒', 0);
INSERT INTO `medicine` VALUES ('m13941', '六味香连胶囊', '胶囊', '江西德瑞制药有限公司', 35.30, '盒', '100', '0.34g*12粒', 0);
INSERT INTO `medicine` VALUES ('m13942', '龙心素胶囊', '胶囊', '云南永安制药有限公司', 29.70, '盒', '100', '0.15g*12粒', 0);
INSERT INTO `medicine` VALUES ('m13943', '卵磷脂络合碘胶囊', '胶囊', '西安力邦制药有限公司', 77.40, '盒', '100', '0.1mg*30粒', 0);
INSERT INTO `medicine` VALUES ('m13944', '罗红霉素胶囊', '胶囊', '扬子江药业集团有限公司', 23.50, '盒', '100', '150mg*12粒', 0);
INSERT INTO `medicine` VALUES ('m13945', '脉络通胶囊', '胶囊', '扬子江药业集团南京海陵药业有限公司', 34.50, '盒', '100', '0.42g*12粒', 0);
INSERT INTO `medicine` VALUES ('m13946', '脑心通胶囊', '胶囊', '陕西步长制药有限公司', 29.80, '盒', '100', '400mg*36粒', 1);
INSERT INTO `medicine` VALUES ('m13947', '宁泌泰胶囊', '胶囊', '贵阳新天药业股份有限公司', 35.70, '盒', '100', '380mg*36粒', 1);
INSERT INTO `medicine` VALUES ('m13948', '泮托拉唑钠肠溶胶囊', '胶囊', '杭州中美华东制药有限公司', 49.50, '盒', '100', '40mg*7片', 1);
INSERT INTO `medicine` VALUES ('m13949', '平消胶囊', '胶囊', '西安正大制药有限公司', 70.20, '盒', '100', '230mg*100粒', 1);
INSERT INTO `medicine` VALUES ('m13950', '芪苈强心胶囊', '胶囊', '石家庄以岭药业股份有限公司', 38.60, '盒', '100', '0.3g*36粒', 1);
INSERT INTO `medicine` VALUES ('m13951', '强筋健骨胶囊', '胶囊', '西安阿房宫药业股份有限公司', 35.10, '盒', '100', '0.3g*36粒', 1);
INSERT INTO `medicine` VALUES ('m13952', '乳酸菌阴道胶囊', '胶囊', '西安正浩生物制药有限公司', 32.80, '盒', '100', '250ug*10枚', 0);
INSERT INTO `medicine` VALUES ('m13953', '苏黄止咳胶囊', '胶囊', '扬子江药业集团北京海燕药业有限公司', 91.50, '盒', '100', '0.45g*24粒', 0);
INSERT INTO `medicine` VALUES ('m13954', '替普瑞酮胶囊', '胶囊', '卫材(中国)药业有限公司', 29.60, '盒', '100', '50mg*20粒', 0);
INSERT INTO `medicine` VALUES ('m13955', '天丹通络胶囊', '胶囊', '山东凤凰制药股份有限公司', 39.90, '盒', '100', '400mg*60s', 1);
INSERT INTO `medicine` VALUES ('m13956', '天麻素胶囊', '胶囊', '昆明制药集团股份有限公司', 24.90, '盒', '100', '50mg*24粒', 1);
INSERT INTO `medicine` VALUES ('m13957', '通心络胶囊', '胶囊', '石家庄以岭药业股份有限公司', 31.60, '盒', '100', '260mg*30粒', 1);
INSERT INTO `medicine` VALUES ('m13958', '翁沥通胶囊', '胶囊', '华北制药股份有限公司', 23.60, '盒', '100', '400mg*24粒', 1);
INSERT INTO `medicine` VALUES ('m13959', '乌灵胶囊', '胶囊', '浙江佐力药业股份有限公司', 46.10, '盒', '100', '0.33g*36粒', 1);
INSERT INTO `medicine` VALUES ('m13960', '小建中胶囊', '胶囊', '贵州太和制药有限公司', 35.70, '盒', '100', '0.4g*24粒', 0);
INSERT INTO `medicine` VALUES ('m13961', '协日嘎四味汤胶囊', '胶囊', '湖南九典制药有限公司', 38.00, '盒', '100', '0.35g*24粒', 0);
INSERT INTO `medicine` VALUES ('m13962', '缬沙坦胶囊', '胶囊', '北京诺华制药有限公司', 45.70, '盒', '100', '80mg*7粒', 0);
INSERT INTO `medicine` VALUES ('m13963', '心速宁胶囊', '胶囊', '陕西摩美得制药有限公司', 37.60, '盒', '100', '0.48g*36粒', 0);
INSERT INTO `medicine` VALUES ('m13964', '血塞通胶囊', '胶囊', '云南维和药业股份有限公司', 29.40, '盒', '100', '0.1g*20粒', 12);
INSERT INTO `medicine` VALUES ('m13965', '血脂康胶囊', '胶囊', '北京北大维信生物科技有限公司', 14.40, '盒', '100', '0.3g*12s', 0);
INSERT INTO `medicine` VALUES ('m13966', '益母草胶囊', '胶囊', '沈阳永大制药有限公司', 23.30, '盒', '100', '0.35g*36粒', 0);
INSERT INTO `medicine` VALUES ('m13967', '益诺胶囊', '胶囊', '广州康和药业有限公司', 72.50, '盒', '100', '0.32g*8粒', 11);
INSERT INTO `medicine` VALUES ('m13968', '益心舒胶囊', '胶囊', '贵州信邦制药股份有限公司', 37.90, '盒', '100', '0.4g*36粒', 12);
INSERT INTO `medicine` VALUES ('m13969', '益血生胶囊', '胶囊', '吉林金复康药业有限公司', 30.70, '盒', '100', '250mg*36粒', 0);
INSERT INTO `medicine` VALUES ('m13970', '致康胶囊', '胶囊', '西安千禾药业有限责任公司', 49.10, '盒', '100', '0.3g*36粒', 0);
INSERT INTO `medicine` VALUES ('m13971', '胶体酒石酸铋胶囊', '胶囊 ', '山西星火维敏制药有限公司', 35.70, '盒', '100', '55mg*24粒', 10);
INSERT INTO `medicine` VALUES ('m13972', '芪胶升白胶囊', '胶囊 ', '贵州汉方药业有限公司', 67.90, '盒', '100', '0.5g*36粒', 0);
INSERT INTO `medicine` VALUES ('m13973', '障眼明胶囊', '胶囊 ', '湖南天济草堂制药有限公司', 31.60, '盒', '100', '0.25g*36粒', 0);
INSERT INTO `medicine` VALUES ('m13974', '骨化三醇胶丸(J)', '胶丸', 'R.P.Scherer GmbH & Co. KG', 62.00, '盒', '100', '0.25ug*10粒', 0);
INSERT INTO `medicine` VALUES ('m13975', '荆花胃康胶丸', '胶丸', '天士力制药集团股份有限公司', 55.90, '盒', '100', '80mg*30s', 0);
INSERT INTO `medicine` VALUES ('m13976', '铝镁二甲硅油咀嚼片', '咀嚼片', '永信药品工业(昆山)有限公司', 47.30, '盒', '100', '0.3719g*30片', 0);
INSERT INTO `medicine` VALUES ('m13977', '孟鲁司特钠咀嚼片', '咀嚼片', '四川大冢制药有限公司', 33.40, '盒', '100', '5mg*5片', 0);
INSERT INTO `medicine` VALUES ('m13978', '维D钙咀嚼片', '咀嚼片', '美国安士制药有限公司生产/安士制药(中山)有限公司分包装', 49.00, '瓶', '100', '300mg*60片', 0);
INSERT INTO `medicine` VALUES ('m13979', '连花清瘟颗粒', '颗粒', '北京以岭药业有限公司', 27.40, '盒', '100', '0.6g*10袋', 0);
INSERT INTO `medicine` VALUES ('m13980', '益视颗粒', '颗粒 ', '山西仁源堂药业有限公司', 35.60, '盒', '100', '15g*9袋', 1);
INSERT INTO `medicine` VALUES ('m13981', '阿莫西林颗粒', '颗粒剂', '珠海联邦制药股份有限公司', 16.40, '盒', '100', '0.125g*24袋', 1);
INSERT INTO `medicine` VALUES ('m13982', '葆宫止血颗粒', '颗粒剂', '天津中盛海天制药有限公司', 36.80, '盒', '100', '15g*6袋', 1);
INSERT INTO `medicine` VALUES ('m13983', '产复康颗粒', '颗粒剂', '深圳三顺制药有限公司', 40.50, '盒', '100', '5g*15袋', 1);
INSERT INTO `medicine` VALUES ('m13984', '产复欣颗粒', '颗粒剂', '吉林省辉南辉发制药股份有限公司', 36.00, '盒', '100', '10g*6袋', 1);
INSERT INTO `medicine` VALUES ('m13985', '复方碳酸钙泡腾颗粒', '颗粒剂', '山东达因海洋生物制药股份有限公司', 26.60, '盒', '100', '1.5g*20袋', 0);
INSERT INTO `medicine` VALUES ('m13986', '甘草锌颗粒', '颗粒剂', '山东达因海洋生物制药股份有限公司', 12.70, '盒', '100', '1.5g*10袋', 1);
INSERT INTO `medicine` VALUES ('m13987', '宫炎康颗粒', '颗粒剂', '陕西白鹿制药股份有限公司', 39.10, '盒', '100', '9g*6袋', 0);
INSERT INTO `medicine` VALUES ('m13988', '红花逍遥颗粒', '颗粒剂', '江西桔王药业有限公司', 44.30, '盒', '100', '3g*12袋', 1);
INSERT INTO `medicine` VALUES ('m13989', '加味生化颗粒', '颗粒剂', '武汉中联集团四药药业有限公司', 25.90, '盒', '100', '15g*10袋', 1);
INSERT INTO `medicine` VALUES ('m13990', '抗感颗粒', '颗粒剂', '四川好医生攀西药业有限责任公司', 19.30, '盒', '100', '5g*12袋', 1);
INSERT INTO `medicine` VALUES ('m13991', '赖氨葡锌颗粒', '颗粒剂', '长沙东风药业有限公司', 34.70, '盒', '100', '5g*20包', 1);
INSERT INTO `medicine` VALUES ('m13992', '赖氨酸维B12颗粒', '颗粒剂', '湖南方盛制药股份有限公司', 24.40, '盒', '100', '10g*10袋', 2);
INSERT INTO `medicine` VALUES ('m13993', '乐孕宁颗粒', '颗粒剂', '江西杏林白马药业有限公司', 37.60, '盒', '100', '5g*12袋', 3);
INSERT INTO `medicine` VALUES ('m13994', '鹿胎颗粒', '颗粒剂', '吉林敖东延边药业股份有限公司', 33.80, '盒', '100', '10g*10袋', 4);
INSERT INTO `medicine` VALUES ('m13995', '母乳多颗粒', '颗粒剂', '陕西康惠制药股份有限公司', 35.40, '盒', '100', '18g*6袋', 5);
INSERT INTO `medicine` VALUES ('m13996', '木丹颗粒', '颗粒剂', '辽宁奥达制药有限公司', 140.00, '盒', '100', '7g*12袋', 2);
INSERT INTO `medicine` VALUES ('m13997', '尿毒清颗粒', '颗粒剂', '康臣药业（内蒙古）有限责任公司', 76.60, '盒', '100', '5g*18袋', 12);
INSERT INTO `medicine` VALUES ('m13998', '匹多莫德颗粒剂', '颗粒剂', '浙江仙琚制药股份有限公司', 47.70, '盒', '100', '0.4g:2g*6袋', 23);
INSERT INTO `medicine` VALUES ('m13999', '热淋清颗粒', '颗粒剂', '贵州威门药业股份有限公司', 36.00, '盒', '100', '4g*8袋', 4);
INSERT INTO `medicine` VALUES ('m14000', '双橘颗粒', '颗粒剂', '江西南昌济生制药厂', 53.10, '盒', '100', '10g*6袋', 1);
INSERT INTO `medicine` VALUES ('m14001', '碳酸钙D3颗粒', '颗粒剂', '北京康远制药有限公司', 31.30, '盒', '100', '0.5g/5ug*6袋', 2);
INSERT INTO `medicine` VALUES ('m14002', '胃苏颗粒', '颗粒剂', '扬子江药业集团江苏制药股份有限公司', 26.60, '盒', '100', '5g*9袋', 12);
INSERT INTO `medicine` VALUES ('m14003', '稳心颗粒', '颗粒剂', '山东步长制药股份有限公司', 28.60, '盒', '100', '9g*9袋', 0);
INSERT INTO `medicine` VALUES ('m14004', '消银颗粒', '颗粒剂', '陕西康惠制药股份有限公司', 28.30, '盒', '100', '3.5g*12袋', 0);
INSERT INTO `medicine` VALUES ('m14005', '小麦纤维素颗粒', '颗粒剂', '瑞典Recip AB', 74.80, '盒', '100', '3.5g*10袋', 1);
INSERT INTO `medicine` VALUES ('m14006', '醒脾养儿颗粒', '颗粒剂', '贵州健兴药业有限公司', 20.70, '盒', '100', '2g*12袋', 1);
INSERT INTO `medicine` VALUES ('m14007', '养血清脑颗粒', '颗粒剂', '天士力制药集团股份有限公司', 36.70, '盒', '100', '4g*15袋', 1);
INSERT INTO `medicine` VALUES ('m14008', '贞芪扶正颗粒', '颗粒剂', '甘肃扶正药业科技股份有限公司', 49.70, '盒', '100', '5g*12袋', 1);
INSERT INTO `medicine` VALUES ('m14009', '珠珀猴枣散', '颗粒剂', '香港保和堂制药有限公司', 59.80, '盒', '100', '0.3g*10袋', 0);
INSERT INTO `medicine` VALUES ('m14010', '硝苯地平控释片', '控释片', '德国 Bayer Schering Pharma AG(拜耳医药保健有限公司分装', 35.80, '盒', '100', '30mg*7片', 1);
INSERT INTO `medicine` VALUES ('m14011', '氨溴特罗口服溶液剂', '口服溶液剂', '北京韩美药品有限公司', 27.60, '瓶', '100', '100ml', 1);
INSERT INTO `medicine` VALUES ('m14012', '鼻窦炎口服液', '口服溶液剂', '太极集团重庆桐君阁药厂有限公司', 14.70, '盒', '100', '10ml*6支', 0);
INSERT INTO `medicine` VALUES ('m14013', '产妇安合剂', '口服溶液剂', '新乡佐今明制药股份有限公司', 33.40, '盒', '100', '25ml*6支', 1);
INSERT INTO `medicine` VALUES ('m14014', '蛋白琥珀酸铁口服溶液', '口服溶液剂', 'ITALFARMACO S.A', 138.00, '盒', '100', '15ml*10支', 0);
INSERT INTO `medicine` VALUES ('m14015', '对乙酰氨基酚混悬液', '口服溶液剂', '上海强生制药有限公司', 15.30, '瓶', '100', '3.2g:100ml', 0);
INSERT INTO `medicine` VALUES ('m14016', '多维铁口服溶液剂', '口服溶液剂', '湖南康寿制药有限公司', 34.20, '瓶', '100', '150ml', 0);
INSERT INTO `medicine` VALUES ('m14017', '复方氨酚甲麻口服溶液剂', '口服溶液剂', '北京韩美药品有限公司', 19.30, '瓶', '100', '100ml', 0);
INSERT INTO `medicine` VALUES ('m14018', '复方福尔可定口服溶液剂', '口服溶液剂', '澳美制药厂', 25.40, '瓶', '100', '150ml', 0);
INSERT INTO `medicine` VALUES ('m14019', '复方红衣补血口服液', '口服溶液剂', '翔宇药业股份有限公司', 20.90, '盒', '100', '10ml*10支', 0);
INSERT INTO `medicine` VALUES ('m14020', '健胃消食口服液', '口服溶液剂', '济川药业集团有限公司', 55.20, '盒', '100', '10ml*12瓶', 10);
INSERT INTO `medicine` VALUES ('m14021', '蓝芩口服液', '口服溶液剂', '扬子江药业集团有限公司', 46.00, '盒', '100', '10ml*12支', 20);
INSERT INTO `medicine` VALUES ('m14022', '葡萄糖酸钙锌口服溶液剂', '口服溶液剂', '澳诺(中国)制药有限公司', 34.00, '盒', '100', '10ml*18支', 12);
INSERT INTO `medicine` VALUES ('m14023', '蒲地蓝口服液', '口服溶液剂', '济川药业集团有限公司', 28.50, '盒', '100', '10ml*6支', 32);
INSERT INTO `medicine` VALUES ('m14024', '芩翘口服液', '口服溶液剂', '沈阳飞龙药业有限公司', 33.90, '盒', '100', '10ml*6支', 0);
INSERT INTO `medicine` VALUES ('m14025', '乳果糖口服溶液剂', '口服溶液剂', '北京韩美药品有限公司', 40.30, '瓶', '100', '66.7g:100ml', 0);
INSERT INTO `medicine` VALUES ('m14026', '双黄连口服液', '口服溶液剂', '河南太龙药业股份有限公司', 20.40, '盒', '100', '10ml*12支', 1);
INSERT INTO `medicine` VALUES ('m14027', '四磨汤口服液', '口服溶液剂', '湖南汉森制药股份有限公司', 24.40, '盒', '100', '10ml*10支', 0);
INSERT INTO `medicine` VALUES ('m14028', '通天口服液', '口服溶液剂', '太极集团重庆涪陵制药厂有限公司', 19.70, '盒', '100', '10ml*6支', 0);
INSERT INTO `medicine` VALUES ('m14029', '茵栀黄口服液', '口服溶液剂', '北京华润高科天然药物有限公司', 21.70, '盒', '100', '10ml*6支', 0);
INSERT INTO `medicine` VALUES ('m14030', '右旋糖酐铁口服溶液剂', '口服溶液剂', '内蒙古康源药业有限公司', 30.60, '盒', '100', '25mg:5ml*10支', 0);
INSERT INTO `medicine` VALUES ('m14031', '孕康口服液', '口服溶液剂', '江西济民可信药业有限公司', 25.90, '盒', '100', '20ml*5支', 0);
INSERT INTO `medicine` VALUES ('m14032', '复方维A酸凝胶', '凝胶', '上海现代制药股份有限公司', 27.70, '支', '100', '10g', 0);
INSERT INTO `medicine` VALUES ('m14033', '黄体酮阴道缓释凝胶', '凝胶剂', 'Fleet laboratories Limited', 1184.00, '盒', '100', '90mg*15支', 0);
INSERT INTO `medicine` VALUES ('m14034', '甲硝唑凝胶', '凝胶剂', '天津市天骄制药有限公司', 30.60, '盒', '100', '37.5mg*7枚', 0);
INSERT INTO `medicine` VALUES ('m14035', '苦参凝胶', '凝胶剂', '贵阳新天药业股份有限公司', 49.70, '盒', '100', '5g*4支', 0);
INSERT INTO `medicine` VALUES ('m14036', '磷酸铝凝胶', '凝胶剂', '韩国保宁制药株式会社', 24.10, '盒', '100', '20g：11g', 0);
INSERT INTO `medicine` VALUES ('m14037', '重组人干扰素a-2b凝胶', '凝胶剂', '兆科药业(合肥)有限公司', 46.40, '支', '100', '5g', 0);
INSERT INTO `medicine` VALUES ('m14038', '妇得康泡沫剂', '泡沫剂', '贵州汉方药业有限公司', 38.60, '瓶', '100', '15g', 0);
INSERT INTO `medicine` VALUES ('m14039', '两性霉素B阴道泡腾片', '泡腾片', '华北制药股份有限公司', 45.50, '盒', '100', '5mg*12片', 0);
INSERT INTO `medicine` VALUES ('m14040', '乙酰半胱氨酸泡腾片', '泡腾片', '浙江金华康恩贝生物制药有限公司', 37.00, '盒', '100', '0.6g*6片', 0);
INSERT INTO `medicine` VALUES ('m14041', '金喉健喷雾剂', '喷雾剂', '贵州宏宇药业有限公司', 24.50, '盒', '100', '20ml', 0);
INSERT INTO `medicine` VALUES ('m14042', '阿卡波糖片(J)', '片剂', 'barer schering pharma AG', 74.20, '盒', '100', '50mg*30片', 0);
INSERT INTO `medicine` VALUES ('m14043', '阿卡波糖片(国)', '片剂', '杭州中美华东制药有限公司', 51.20, '盒', '100', '50mg*30片', 0);
INSERT INTO `medicine` VALUES ('m14044', '阿仑膦酸钠片', '片剂', 'Merck Sharp&Dohme(Italia)SPA', 70.80, '盒', '100', '70mg*1片', 12);
INSERT INTO `medicine` VALUES ('m14045', '阿托伐他汀钙片(J)', '片剂', 'Pfizer Ireland Pharmaceuticals', 72.20, '盒', '100', '20mg*7片', 0);
INSERT INTO `medicine` VALUES ('m14046', '阿托伐他汀钙片(国)', '片剂', '北京嘉林药业股份有限公司', 31.10, '盒', '100', '10mg*7片', 0);
INSERT INTO `medicine` VALUES ('m14047', '艾地苯醌片', '片剂', '深圳海王药业有限公司', 56.30, '盒', '100', '30mg*12片', 0);
INSERT INTO `medicine` VALUES ('m14048', '氨基葡萄糖片', '片剂', '四川绿叶宝光药业股份有限公司', 38.20, '盒', '100', '0.24g*30片', 0);
INSERT INTO `medicine` VALUES ('m14049', '氨氯地平片', '片剂', '辉瑞制药有限公司', 38.00, '盒', '100', '5mg*7片', 1);
INSERT INTO `medicine` VALUES ('m14050', '昂丹司琼片', '片剂', '齐鲁制药有限公司', 181.00, '盒', '100', '4mg*12片', 0);
INSERT INTO `medicine` VALUES ('m14051', '奥美拉唑镁肠溶片', '片剂', 'AstraZeneca.AB', 94.30, '盒', '100', '20mg*7片', 1);
INSERT INTO `medicine` VALUES ('m14052', '贝尼地平片', '片剂', '华夏药业集团有限公司', 34.50, '盒', '100', '2mg*24片', 1);
INSERT INTO `medicine` VALUES ('m14053', '薄芝片', '片剂', '浙江瑞新药业股份有限公司', 48.70, '盒', '100', '0.16g*60片', 1);
INSERT INTO `medicine` VALUES ('m14054', '草木犀流浸液片', '片剂', '生晃荣养药品株式会社Seiko Eiyo Yakuhin Co.，LTD', 46.00, '盒', '100', '25mg*50片', 1);
INSERT INTO `medicine` VALUES ('m14055', '醋甲唑胺片', '片剂', '杭州澳医保灵药业有限公司', 29.90, '盒', '100', '25mg*10s', 1);
INSERT INTO `medicine` VALUES ('m14056', '单硝酸异山梨酯片', '片剂', '鲁南贝特制药有限公司', 47.80, '盒', '100', '20mg*48片', 0);
INSERT INTO `medicine` VALUES ('m14057', '地屈孕酮片', '片剂', 'Abbott Biologicals B.V.', 131.00, '盒', '98', '10mg*20片', 3);
INSERT INTO `medicine` VALUES ('m14058', '递法明片', '片剂', '法国乐康美的澜制药厂', 75.80, '盒', '100', '0.4g*20片', 0);
INSERT INTO `medicine` VALUES ('m14059', '多潘立酮片', '片剂', '西安杨森制药有限公司', 22.40, '盒', '100', '10mg*42片', 1);
INSERT INTO `medicine` VALUES ('m14060', '厄贝沙坦片', '片剂', 'Sanofi Winthrop Industrie', 36.90, '盒', '100', '150mg*7片', 1);
INSERT INTO `medicine` VALUES ('m14061', '厄贝沙坦氢氯噻嗪片', '片剂', 'Sanofi Winthrop Industrie', 37.10, '盒', '100', '150mg*7片', 1);
INSERT INTO `medicine` VALUES ('m14062', '二甲双胍片(J）', '片剂', '中美上海施贵宝制药有限公司', 28.90, '盒', '100', '0.5g*20片', 0);
INSERT INTO `medicine` VALUES ('m14063', '非索非那定片', '片剂', '浙江万晟药业有限公司', 24.50, '盒', '100', '30mg*28片', 1);
INSERT INTO `medicine` VALUES ('m14064', '氟哌噻吨美利曲辛片', '片剂', 'H.Lundbeck A/S 丹麦灵北制药有限公司', 66.70, '盒', '100', '10.5mg*20片', 1);
INSERT INTO `medicine` VALUES ('m14065', '妇乐片', '片剂', '陕西东泰制药有限公司', 39.30, '盒', '100', '0.5g*30片', 0);
INSERT INTO `medicine` VALUES ('m14066', '复方醋酸棉酚片', '片剂', '西安北方药业有限公司', 64.40, '盒', '100', '20mg*5片', 1);
INSERT INTO `medicine` VALUES ('m14067', '复方硫酸亚铁叶酸片', '片剂', '吉林省西点药业科技发展股份有限公司', 34.90, '盒', '100', '50mg*36粒', 11);
INSERT INTO `medicine` VALUES ('m14068', '复方米非司酮片', '片剂', '湖北葛店人福药业有限责任公司', 67.90, '盒', '100', '35mg*2片', 12);
INSERT INTO `medicine` VALUES ('m14069', '复方嗜酸乳杆菌片', '片剂', '通化金马药业集团股份有限公司', 37.70, '盒', '100', '0.5g*18片', 1);
INSERT INTO `medicine` VALUES ('m14070', '复方夏天无片', '片剂', '江西天施康中药股份有限公司', 27.10, '盒', '100', '0.32g*42s', 1);
INSERT INTO `medicine` VALUES ('m14071', '复方血栓通片', '片剂', '扬州中惠制药有限公司', 32.20, '盒', '100', '0.4g*36片', 1);
INSERT INTO `medicine` VALUES ('m14072', '复明片', '片剂', '西安碑林药业股份有限公司', 30.90, '盒', '100', '310mg*90s', 0);
INSERT INTO `medicine` VALUES ('m14073', '格列美脲片(J)', '片剂', '赛诺菲（北京）制药有限公司', 77.90, '盒', '100', '2mg*15片', 1);
INSERT INTO `medicine` VALUES ('m14074', '格列美脲片(国)', '片剂', '山东达因海洋生物制药股份有限公司', 29.30, '盒', '100', '2mg*24片', 1);
INSERT INTO `medicine` VALUES ('m14075', '和血明目片', '片剂', '西安碑林药业股份有限公司', 44.20, '盒', '100', '300mg*60片', 11);
INSERT INTO `medicine` VALUES ('m14076', '琥珀酸亚铁片', '片剂', '金陵药业股份有限公司南京金陵制药厂', 29.90, '盒', '100', '0.1g*24片', 1);
INSERT INTO `medicine` VALUES ('m14077', '琥乙红霉素片', '片剂', '西安利君制药有限责任公司', 11.70, '盒', '100', '0.125g*24片', 1);
INSERT INTO `medicine` VALUES ('m14078', '甲钴胺片', '片剂', '江苏德源药业股份有限公司', 19.70, '盒', '100', '0.5mg*24片', 12);
INSERT INTO `medicine` VALUES ('m14079', '甲巯咪唑片（J）', '片剂', 'Merck KGaA', 33.00, '盒', '100', '10mg*50片', 0);
INSERT INTO `medicine` VALUES ('m14080', '卡维地洛片', '片剂', 'JK齐鲁制药有限公司', 16.20, '盒', '100', '12.5mg*14片', 0);
INSERT INTO `medicine` VALUES ('m14081', '坎地沙坦酯片', '片剂', '重庆圣华曦药业股份有限公司', 22.70, '盒', '100', '4mg*14片', 0);
INSERT INTO `medicine` VALUES ('m14082', '克霉唑阴道片(J)', '片剂', 'Bayer Pharma AG', 47.20, '盒', '100', '0.5g*1片', 0);
INSERT INTO `medicine` VALUES ('m14083', '克霉唑阴道片(国)', '片剂', '湖南华纳大药厂有限公司', 29.70, '盒', '100', '0.5g*3片', 0);
INSERT INTO `medicine` VALUES ('m14084', '坤复康片', '片剂', '广东在田药业有限公司', 49.30, '盒', '100', '0.45g*48片', 0);
INSERT INTO `medicine` VALUES ('m14085', '来曲唑片', '片剂', '江苏恒瑞医药股份有限公司', 149.00, '盒', '100', '2.5mg*10片', 10);
INSERT INTO `medicine` VALUES ('m14086', '利托君片', '片剂', '广东先强药业股份有限公司', 50.00, '盒', '100', '10mg*10片', 1);
INSERT INTO `medicine` VALUES ('m14087', '铝碳酸镁片', '片剂', 'K拜耳医药保健有限公司', 23.90, '盒', '100', '0.5g*20片', 1);
INSERT INTO `medicine` VALUES ('m14088', '氯沙坦钾片', '片剂', '扬子江药业集团四川海蓉药业有限公司', 37.30, '盒', '100', '50mg*7片', 1);
INSERT INTO `medicine` VALUES ('m14089', '迈之灵片', '片剂', '德国礼达大药厂', 49.90, '盒', '100', '150mg*20片', 0);
INSERT INTO `medicine` VALUES ('m14090', '脉君安片', '片剂', '武汉中联集团四药药业有限公司', 22.40, '盒', '100', '500mg*48片', 1);
INSERT INTO `medicine` VALUES ('m14091', '米非司酮/米索前列醇片', '片剂', '华润紫竹药业有限公司', 55.50, '盒', '100', '25mg*6片/0.2g*3片', 1);
INSERT INTO `medicine` VALUES ('m14092', '米非司酮片', '片剂', '华润紫竹药业有限公司', 24.30, '盒', '100', '25mg*6片', 0);
INSERT INTO `medicine` VALUES ('m14093', '莫沙必利片', '片剂', '江苏豪森药业股份有限公司', 21.50, '盒', '100', '5mg*24片', 1);
INSERT INTO `medicine` VALUES ('m14094', '莫沙必利片(J)', '片剂', '住友制药（苏州）有限公司', 25.60, '盒', '100', '5mg*10片', 1);
INSERT INTO `medicine` VALUES ('m14095', '莫西沙星片', '片剂', '德国 Bayer Schering Pharma AG(拜耳医药保健有限公司分装)', 87.20, '盒', '100', '400mg*3片', 0);
INSERT INTO `medicine` VALUES ('m14096', '凝结芽孢杆菌活菌片', '片剂', '青岛东海药业有限公司', 40.40, '盒', '100', '0.35g*30片', 1);
INSERT INTO `medicine` VALUES ('m14097', '七叶皂苷钠片', '片剂', '山东绿叶制药有限公司', 50.00, '盒', '100', '30mg*24片', 0);
INSERT INTO `medicine` VALUES ('m14098', '曲美他嗪片', '片剂', '施维雅(天津)制药有限公司', 53.60, '盒', '100', '20mg*30片', 1);
INSERT INTO `medicine` VALUES ('m14099', '炔雌醇环丙孕酮片', '片剂', '德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)', 59.80, '盒', '100', '2.035mg*21片', 0);
INSERT INTO `medicine` VALUES ('m14100', '乳增宁片', '片剂', '深圳三顺制药有限公司', 50.00, '盒', '100', '0.6g*60s', 0);
INSERT INTO `medicine` VALUES ('m14101', '瑞格列奈片(J)', '片剂', '德国Boehringer Ingelheim Pharma GmbH & Co.KG', 74.20, '盒', '100', '1mg*30片', 0);
INSERT INTO `medicine` VALUES ('m14102', '瑞格列奈片(国)', '片剂', '江苏豪森药业股份有限公司', 21.60, '盒', '100', '0.5mg*30片 ', 0);
INSERT INTO `medicine` VALUES ('m14103', '瑞舒伐他汀片', '片剂', '浙江京新药业股份有限公司', 35.20, '盒', '100', '5mg*12片', 20);
INSERT INTO `medicine` VALUES ('m14104', '双歧杆菌乳杆菌三联活菌片', '片剂', '内蒙古双奇药业股份有限公司', 36.70, '盒', '100', '500mg*36片', 2);
INSERT INTO `medicine` VALUES ('m14105', '司他斯汀片', '片剂', '回音必集团抚州制药有限公司', 41.00, '盒', '100', '1mg*20片', 2);
INSERT INTO `medicine` VALUES ('m14106', '替勃龙片', '片剂', '华润紫竹药业有限公司', 36.20, '盒', '100', '2.5mg*7片', 3);
INSERT INTO `medicine` VALUES ('m14107', '替勃龙片(J)', '片剂', '南京欧加农制药有限公司', 48.90, '盒', '100', '2.5mg*7片', 3);
INSERT INTO `medicine` VALUES ('m14108', '替米沙坦片', '片剂', 'Boehringer Ingelheim International GmbH', 43.40, '盒', '100', '80mg*7片', 1);
INSERT INTO `medicine` VALUES ('m14109', '胃复春片', '片剂', '杭州胡庆余堂药业有限公司', 20.60, '盒', '100', '359mg*60片', 1);
INSERT INTO `medicine` VALUES ('m14110', '戊酸雌二醇/雌二醇环丙孕酮片', '片剂', '德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)', 77.10, '盒', '100', '2mg*11片/2mg*10片', 1);
INSERT INTO `medicine` VALUES ('m14111', '戊酸雌二醇片', '片剂', '德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)', 32.80, '盒', '100', '1mg*21片', 1);
INSERT INTO `medicine` VALUES ('m14112', '西格列汀片', '片剂', 'Merck Sharp & Dohme Italia SPA', 63.90, '盒', '100', '100mg*7片', 0);
INSERT INTO `medicine` VALUES ('m14113', '香菊片', '片剂', '陕西白云制药有限公司', 36.70, '盒', '100', '0.32g*72片', 0);
INSERT INTO `medicine` VALUES ('m14114', '心可舒片', '片剂', '山东沃华医药科技股份有限公司', 24.10, '盒', '100', '310mg*48片', 0);
INSERT INTO `medicine` VALUES ('m14115', '心神宁片', '片剂', '延安常泰药业有限责任公司', 39.30, '盒', '100', '250mg*80片', 0);
INSERT INTO `medicine` VALUES ('m14116', '辛伐他汀片', '片剂', 'Merck Sharp & Dohme B.V.', 24.20, '盒', '100', '20mg*7片', 0);
INSERT INTO `medicine` VALUES ('m14117', '辛芩片', '片剂', '四川志远广和制药有限公司', 33.90, '盒', '100', '0.8g*36s', 0);
INSERT INTO `medicine` VALUES ('m14118', '杏香兔耳风片', '片剂', '江西天施康中药股份有限公司', 46.90, '盒', '100', '0.3g*72s', 0);
INSERT INTO `medicine` VALUES ('m14119', '血塞通片', '片剂', '云南特安呐制药股份有限公司', 37.00, '盒', '100', '50mg*60片', 0);
INSERT INTO `medicine` VALUES ('m14120', '血栓心脉宁片', '片剂', '吉林华康药业股份有限公司', 33.60, '盒', '100', '0.4g*18片', 0);
INSERT INTO `medicine` VALUES ('m14121', '依那普利片（大）', '片剂', '扬子江药业集团江苏制药股份有限公司', 28.00, '盒', '100', '10mg*32片', 0);
INSERT INTO `medicine` VALUES ('m14122', '依帕司他片', '片剂', '扬子江药业集团南京海陵药业有限公司', 43.60, '盒', '100', '50mg*10片', 0);
INSERT INTO `medicine` VALUES ('m14123', '益脉康分散片', '片剂', '云南白药集团大理药业有限责任公司', 40.40, '盒', '100', '0.55g*36s', 0);
INSERT INTO `medicine` VALUES ('m14124', '益气补血片', '片剂', '四平市吉特药业有限公司', 33.10, '盒', '100', '60片', 0);
INSERT INTO `medicine` VALUES ('m14125', '银花泌炎灵片', '片剂', '吉林华康药业股份有限公司', 45.90, '盒', '100', '0.5g*36片', 0);
INSERT INTO `medicine` VALUES ('m14126', '银杏叶片(大)', '片剂', '贵州信邦制药股份有限公司', 25.30, '盒', '100', '19.2mg*24片', 0);
INSERT INTO `medicine` VALUES ('m14127', '银杏叶片(小)', '片剂', '扬子江药业集团有限公司', 25.50, '盒', '100', '9.6mg*36片', 0);
INSERT INTO `medicine` VALUES ('m14128', '左旋氨氯地平片', '片剂', '扬子江药业集团上海海尼药业有限公司', 14.50, '盒', '100', '2.5mg*7片', 0);
INSERT INTO `medicine` VALUES ('m14129', '左旋氨氯地平片', '片剂', '施慧达药业集团（吉林）有限公司', 34.80, '盒', '100', '2.5mg*14片', 0);
INSERT INTO `medicine` VALUES ('m14130', '左炔诺孕酮宫内节育器', '其它', '芬兰 Bayer Schering Pharma Oy(拜耳医药保健有限公司广州分公司分装)', 1265.00, '盒', '100', '52mg', 0);
INSERT INTO `medicine` VALUES ('m14131', '沙丁胺醇气雾剂', '气雾剂', 'Glaxo Wellcome S.A.', 23.50, '支', '100', '100ug*200揿', 0);
INSERT INTO `medicine` VALUES ('m14132', '沙美特罗替卡松粉吸入剂', '气雾剂', 'Glaxo Operations UK Limited', 251.00, '盒', '100', '50ug/250ug*60喷', 0);
INSERT INTO `medicine` VALUES ('m14133', '环孢素软胶囊', '软胶囊', '丽珠集团丽珠制药厂', 250.00, '盒', '100', '25mg*48粒', 0);
INSERT INTO `medicine` VALUES ('m14134', '硝呋太尔制霉素软胶囊', '软胶囊', '北京朗依制药有限公司', 43.90, '盒', '100', '500mg:20ug*6粒', 0);
INSERT INTO `medicine` VALUES ('m14135', '复方聚乙二醇电解质散', '散剂', '深圳万和制药有限公司', 42.90, '袋', '100', '68.56g', 0);
INSERT INTO `medicine` VALUES ('m14136', '蒙脱石散(J）', '散剂', 'JK博福一益普生(天津)制药有限公司', 22.20, '盒', '100', '3g*10袋', 0);
INSERT INTO `medicine` VALUES ('m14137', '脾氨肽口服冻干粉', '散剂', '大连百利天华制药有限公司', 121.00, '盒', '100', '2mg*5瓶', 0);
INSERT INTO `medicine` VALUES ('m14138', '小儿牛黄清心散', '散剂', '山东方健制药有限公司', 35.90, '盒', '100', '0.3g*8袋', 0);
INSERT INTO `medicine` VALUES ('m14139', '保妇康栓', '栓剂', '海南碧凯药业有限公司', 26.30, '盒', '100', '1.74g*8粒', 0);
INSERT INTO `medicine` VALUES ('m14140', '博性康药膜', '栓剂', '贵州大华制药有限公司', 29.80, '盒', '100', '5cm*7cm*12片', 0);
INSERT INTO `medicine` VALUES ('m14141', '地诺前列酮栓', '栓剂', 'Controlled Therapeutics（Scotland）Limited', 472.00, '盒', '100', '10mg', 0);
INSERT INTO `medicine` VALUES ('m14142', '复方角菜酸酯栓', '栓剂', '西安杨森制药有限公司', 16.00, '盒', '100', '3.4g*6枚', 0);
INSERT INTO `medicine` VALUES ('m14143', '复方沙棘籽油栓', '栓剂', '陕西海天制药有限公司', 33.00, '盒', '100', '2.7g*7粒', 0);
INSERT INTO `medicine` VALUES ('m14144', '甲硝唑呋喃唑酮栓', '栓剂', '哈药集团制药总厂', 24.30, '盒', '100', '101.6mg*5粒', 0);
INSERT INTO `medicine` VALUES ('m14145', '康妇消炎栓', '栓剂', '葵花药业集团（伊春）有限公司', 32.50, '盒', '100', '2.8g*9粒', 0);
INSERT INTO `medicine` VALUES ('m14146', '咪康唑栓', '栓剂', '法国Catalent France Beinheim S.A.', 25.60, '盒', '100', '400mg*3粒', 0);
INSERT INTO `medicine` VALUES ('m14147', '咪康唑栓', '栓剂', '法国Catalent France Beinheim S.A', 30.50, '盒', '100', '1200mg*1粒', 0);
INSERT INTO `medicine` VALUES ('m14148', '重组人干扰素a-2b栓', '栓剂', '安徽安科生物工程(集团)股份有限公司', 52.90, '盒', '100', '10万u*10枚', 0);
INSERT INTO `medicine` VALUES ('m14149', '沙丁胺醇溶液', '外用溶液', 'laxo Wellcome Operations', 61.90, '瓶', '100', '100mg:20ml', 0);
INSERT INTO `medicine` VALUES ('m14150', '苯扎氯铵溶液', '外用溶液剂', '汕头保税区洛斯特制药有限公司', 58.70, '瓶', '100', '150ml', 0);
INSERT INTO `medicine` VALUES ('m14151', '红核妇洁洗液', '外用溶液剂', '山东步长神州制药有限公司', 32.60, '盒', '100', '10ml*10袋', 0);
INSERT INTO `medicine` VALUES ('m14152', '洁肤净洗液', '外用溶液剂', '西安仁仁药业有限公司', 25.20, '盒', '100', '200ml', 0);
INSERT INTO `medicine` VALUES ('m14153', '皮肤康洗液', '外用溶液剂', '北京华洋奎龙药业有限公司', 23.50, '盒', '100', '50ml', 0);
INSERT INTO `medicine` VALUES ('m14154', '阴痒康洗剂', '外用溶液剂', '河南润弘制药股份有限公司', 35.40, '盒', '100', '160ml', 0);
INSERT INTO `medicine` VALUES ('m14155', '定坤丹', '丸剂', '山西广誉远国药有限公司', 66.60, '盒', '100', '7g*6袋', 0);
INSERT INTO `medicine` VALUES ('m14156', '断血流滴丸', '丸剂', '甘肃益尔药业股份有限公司', 44.90, '盒', '100', '3g*9袋', 0);
INSERT INTO `medicine` VALUES ('m14157', '固肾安胎丸', '丸剂', '北京勃然制药有限公司', 54.40, '盒', '100', '6g*9袋', 0);
INSERT INTO `medicine` VALUES ('m14158', '桂附地黄丸', '丸剂', '河南省宛西制药股份有限公司', 11.40, '盒', '100', '200粒', 0);
INSERT INTO `medicine` VALUES ('m14159', '六味地黄丸', '丸剂', '河南省宛西制药股份有限公司', 11.50, '盒', '100', '200粒', 0);
INSERT INTO `medicine` VALUES ('m14160', '明目上清丸', '丸剂', '陕西利君现代中药有限公司', 28.50, '盒', '100', '9g*8袋', 0);
INSERT INTO `medicine` VALUES ('m14161', '杞菊地黄丸', '丸剂', '河南省宛西制药股份有限公司', 11.40, '盒', '100', '200粒', 0);
INSERT INTO `medicine` VALUES ('m14162', '速效救心丸', '丸剂', '天津中新药业集团股份有限公司第六中药厂', 29.20, '盒', '100', '40mg*150s', 0);
INSERT INTO `medicine` VALUES ('m14163', '知柏地黄丸', '丸剂', '河南省宛西制药股份有限公司', 11.40, '盒', '100', '200粒', 0);
INSERT INTO `medicine` VALUES ('m14164', '沙美特罗替卡松粉吸入剂', '吸入剂', 'Glaxo Operations UK Limited', 383.00, '盒', '100', '500ug*60吸', 0);
INSERT INTO `medicine` VALUES ('m14165', '妥布霉素地塞米松眼膏', '眼膏', 's.a.ALCON-COUVREUR n.v.', 37.10, '支', '100', '3.5g', 0);
INSERT INTO `medicine` VALUES ('m14166', '妥布霉素眼膏', '眼膏', 's.a.ALCON-COUVREUR n.v.', 30.40, '支', '100', '3.5g', 0);
INSERT INTO `medicine` VALUES ('m14167', '氧氟沙星眼膏', '眼膏', '沈阳兴齐眼药股份有限公司', 17.80, '支', '100', '3.5g', 0);
INSERT INTO `medicine` VALUES ('m14168', '氧氟沙星眼膏(J)', '眼膏', '参天制药株式会社', 28.40, '支', '100', '3.5g', 0);
INSERT INTO `medicine` VALUES ('m14169', '阿托品眼用凝胶', '眼用凝胶', '沈阳兴齐眼药股份有限公司', 19.00, '支', '100', '2.5g', 0);
INSERT INTO `medicine` VALUES ('m14170', '更昔洛韦眼用凝胶', '眼用凝胶', '湖北科益药业股份有限公司', 26.10, '支', '100', '5g', 10);
INSERT INTO `medicine` VALUES ('m14171', '卡波姆眼用凝胶', '眼用凝胶', 'Dr.Gerhard Mann. Chem.-Pharm. Fabrik Gmbh', 51.90, '支', '100', '20mg：10g', 0);
INSERT INTO `medicine` VALUES ('m14172', '维生素A棕榈酸酯眼用凝胶', '眼用凝胶', '沈阳兴齐眼药股份有限公司', 34.70, '支', '100', '5g:5000IU', 0);
INSERT INTO `medicine` VALUES ('m14173', '小牛血去蛋白眼用凝胶', '眼用凝胶', '沈阳兴齐眼药股份有限公司', 49.70, '支', '100', '5g', 0);
INSERT INTO `medicine` VALUES ('m14174', '重组牛碱性成纤维细胞生长因子眼用凝胶', '眼用凝胶', '珠海亿胜生物制药有限公司', 41.20, '支', '100', '2.1万U:5g', 0);
INSERT INTO `medicine` VALUES ('m14175', '左氧氟沙星眼用凝胶', '眼用凝胶', '湖北远大天天明制药有限公司', 19.90, '支', '100', '5g', 0);
INSERT INTO `medicine` VALUES ('m14176', '重组人干扰素a2b阴道泡腾胶囊', '阴道泡腾胶囊', '上海华新生物高技术有限公司', 74.00, '盒', '100', '80万IU*4粒', 0);
INSERT INTO `medicine` VALUES ('m14177', '复方氨基酸注射液18AA-Ⅳ', '针剂', '广东利泰制药股份有限公司', 59.10, '瓶', '100', '8.7g:250ml', 0);
INSERT INTO `medicine` VALUES ('m14178', '拉贝洛尔注射液', '针剂', '江苏迪赛诺制药有限公司', 39.80, '支', '100', '50mg:10ml', 0);
INSERT INTO `medicine` VALUES ('m14179', '左氧氟沙星氯化钠注射液', '针剂', '扬子江药业集团有限公司', 27.60, '瓶', '100', '0.2g:100ml', 0);
INSERT INTO `medicine` VALUES ('m14180', '氨碘肽注射液', '注射剂', '杭州国光药业有限公司', 14.90, '支', '100', '2ml', 0);
INSERT INTO `medicine` VALUES ('m14181', '氨溴索葡萄糖注射液', '注射剂', '石家庄四药有限公司', 11.80, '瓶', '100', '30mg:50ml', 10);
INSERT INTO `medicine` VALUES ('m14182', '胺碘酮注射液', '注射剂', 'Sanofi Winthrop Industrie', 30.00, '支', '100', '150mg:3ml', 2);
INSERT INTO `medicine` VALUES ('m14183', '昂丹司琼注射液', '注射剂', '威海爱威制药有限公司', 37.10, '袋', '100', '8mg:100ml', 3);
INSERT INTO `medicine` VALUES ('m14184', '奥拉西坦注射液', '注射剂', '广东世信药业有限公司', 67.70, '支', '100', '1g:5ml', 0);
INSERT INTO `medicine` VALUES ('m14185', '奥曲肽注射液(J)', '注射剂', '诺华Novartis Pharma Stein AG', 116.00, '支', '100', '0.1mg:1ml', 2);
INSERT INTO `medicine` VALUES ('m14186', '奥曲肽注射液(国）', '注射剂', '国药一心制药有限公司', 90.40, '支', '100', '0.2mg:1ml', 12);
INSERT INTO `medicine` VALUES ('m14187', '吡拉西坦氯化钠注射液', '注射剂', '山东威高药业股份有限公司', 24.50, '瓶', '100', '10g: 50ml', 2);
INSERT INTO `medicine` VALUES ('m14188', '丙泊酚注射液(J)', '注射剂', 'Corden Pharma S.P.A （意大利）', 88.80, '支', '100', '0.2g:20ml', 3);
INSERT INTO `medicine` VALUES ('m14189', '丙泊酚注射液（国）', '注射剂', '四川国瑞药业有限责任公司', 38.50, '支', '100', '0.2g:20ml', 3);
INSERT INTO `medicine` VALUES ('m14190', '玻璃酸钠注射液', '注射剂', '上海景峰制药有限公司', 176.00, '支', '100', '25mg：2.5ml', 4);
INSERT INTO `medicine` VALUES ('m14191', '玻璃酸钠注射液', '注射剂', '日本生化学工业株式会社', 218.00, '支', '100', '25mg:2.5ml', 1);
INSERT INTO `medicine` VALUES ('m14192', '参麦注射液', '注射剂', '四川升和药业股份有限公司', 24.90, '支', '100', '20ml', 2);
INSERT INTO `medicine` VALUES ('m14193', '参芎葡萄糖注射液', '注射剂', '贵州景峰注射剂有限公司', 56.40, '瓶', '100', '0.12g:100ml', 4);
INSERT INTO `medicine` VALUES ('m14194', '长春西汀葡萄糖注射液（玻）', '注射剂', '华仁药业（日照）有限公司', 24.70, '瓶', '100', '10mg:100ml', 2);
INSERT INTO `medicine` VALUES ('m14195', '丹参川芎嗪注射液', '注射剂', '贵州拜特制药有限公司', 45.40, '支', '100', '5ml', 1);
INSERT INTO `medicine` VALUES ('m14196', '单硝酸异山梨酯注射液', '注射剂', '鲁南贝特制药有限公司', 29.10, '支', '100', '20mg:5ml', 2);
INSERT INTO `medicine` VALUES ('m14197', '灯盏细辛注射液', '注射剂', '云南生物谷药业股份有限公司', 22.50, '支', '100', '45mg:10ml', 4);
INSERT INTO `medicine` VALUES ('m14198', '地特胰岛素注射液（特充）', '注射剂', '诺和诺德（中国）制药有限公司', 237.00, '支', '100', '300U：3ml', 1);
INSERT INTO `medicine` VALUES ('m14199', '碘佛醇注射液', '注射剂', '江苏恒瑞医药股份有限公司', 78.80, '瓶', '100', '13.56g:20ml', 5);
INSERT INTO `medicine` VALUES ('m14200', '碘佛醇注射液', '注射剂', 'tyco Heal thcare', 381.00, '瓶', '100', '35g:100ml', 3);
INSERT INTO `medicine` VALUES ('m14201', '碘海醇注射液', '注射剂', '扬子江药业集团有限公司', 160.00, '瓶', '100', '15g:50ml', 25);
INSERT INTO `medicine` VALUES ('m14202', '碘海醇注射液', '注射剂', '扬子江药业集团有限公司', 272.00, '瓶', '100', '30g:100ml', 23);
INSERT INTO `medicine` VALUES ('m14203', '碘克沙醇注射液', '注射剂', 'GE Healthcare Ireland', 756.00, '瓶', '100', '32g:100ml', 2);
INSERT INTO `medicine` VALUES ('m14204', '多索茶碱注射液', '注射剂', '黑龙江福和华星制药集团股份有限公司', 15.60, '支', '100', '0.1g:10ml', 5);
INSERT INTO `medicine` VALUES ('m14205', '多西他赛注射液', '注射剂', '江苏恒瑞医药股份有限公司', 472.00, '支', '100', '20mg：0.5ml', 2);
INSERT INTO `medicine` VALUES ('m14206', '多烯磷酯酰胆碱注射液', '注射剂', '成都天台山制药有限公司', 25.30, '支', '100', '232.5mg:5ml', 3);
INSERT INTO `medicine` VALUES ('m14207', '多种微量元素注射液', '注射剂', '华瑞制药有限公司', 13.50, '支', '100', '10ml', 4);
INSERT INTO `medicine` VALUES ('m14208', '复方氨基酸注射液18AA-II', '注射剂', '华瑞制药有限公司', 26.70, '瓶', '100', '8.5%:250ml', 2);
INSERT INTO `medicine` VALUES ('m14209', '复方樟柳碱注射液', '注射剂', '华润紫竹药业有限公司', 23.00, '支', '100', '2mg:2ml', 4);
INSERT INTO `medicine` VALUES ('m14210', '钆喷酸葡胺注射液', '注射剂', '广州康臣药业有限公司', 169.00, '支', '100', '20ml:9.38g', 0);
INSERT INTO `medicine` VALUES ('m14211', '钆喷酸葡胺注射液', '注射剂', '德国 Bayer Schering Pharma AG (拜耳医药保健有限公司广州分公司分装)', 194.00, '瓶', '100', '469.01mg/ml*15ml', 0);
INSERT INTO `medicine` VALUES ('m14212', '甘精胰岛素注射液', '注射剂', 'Sanofi-Aventis Deutschland GmbH', 237.00, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14213', '甘舒霖30R笔芯', '注射剂', '通化东宝药业股份有限公司', 56.20, '支', '100', '300IU:3ml', 0);
INSERT INTO `medicine` VALUES ('m14214', '甘舒霖N笔芯', '注射剂', '通化东宝药业股份有限公司', 56.20, '支', '100', '300U:3ml', 0);
INSERT INTO `medicine` VALUES ('m14215', '甘舒霖R笔芯', '注射剂', '通化东宝药业股份有限公司', 56.20, '支', '100', '300U:3ml', 0);
INSERT INTO `medicine` VALUES ('m14216', '甘油果糖氯化钠注射液', '注射剂', '四川科伦药业股份有限公司', 24.20, '袋', '100', '250ml', 0);
INSERT INTO `medicine` VALUES ('m14217', '格拉司琼葡萄糖注射液', '注射剂', '江苏晨牌药业集团股份有限公司', 22.90, '瓶', '100', '3mg:50ml', 0);
INSERT INTO `medicine` VALUES ('m14218', '桂哌齐特注射液', '注射剂', '北京四环制药有限公司', 49.00, '支', '100', '80mg:2ml', 0);
INSERT INTO `medicine` VALUES ('m14219', '果糖注射液', '注射剂', '江苏正大丰海制药有限公司', 30.80, '瓶', '100', '12.5g:250ml', 0);
INSERT INTO `medicine` VALUES ('m14220', '红花注射液', '注射剂', '山西华卫药业有限公司', 20.80, '支', '100', '10ml', 0);
INSERT INTO `medicine` VALUES ('m14221', '混合糖电解质注射液', '注射剂', '江苏正大丰海制药有限公司', 124.00, '瓶', '100', '500ml', 0);
INSERT INTO `medicine` VALUES ('m14222', '卡贝缩宫素注射液', '注射剂', 'Ferring Inc', 298.00, '支', '100', '100ug:1ml', 0);
INSERT INTO `medicine` VALUES ('m14223', '卡前列素氨丁三醇注射液', '注射剂', 'Pharmacia & Upjohn Company', 537.00, '支', '100', '250ug:1ml', 0);
INSERT INTO `medicine` VALUES ('m14224', '苦碟子注射液', '注射剂', '通化华夏药业有限责任公司', 21.30, '支', '100', '250mg:10ml', 0);
INSERT INTO `medicine` VALUES ('m14225', '利奈唑胺注射液', '注射剂', '挪威 Fresenius Kabi Norge AS', 453.00, '袋', '100', '0.6g:300ml', 0);
INSERT INTO `medicine` VALUES ('m14226', '利托君注射液', '注射剂', '广东先强药业股份有限公司', 35.20, '支', '100', '50mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m14227', '硫辛酸注射液', '注射剂', '亚宝药业集团股份有限公司', 33.20, '支', '100', '0.15g:6ml', 0);
INSERT INTO `medicine` VALUES ('m14228', '罗哌卡因注射液', '注射剂', 'Astrazeneca AB （瑞典））', 57.00, '支', '100', '0.1g:10ml', 0);
INSERT INTO `medicine` VALUES ('m14229', '莫西沙星氯化钠注射液', '注射剂', '德国 Bayer Schering Pharma AG(拜耳医药保健有限公司分装)', 316.00, '瓶', '100', '0.4g:250ml', 0);
INSERT INTO `medicine` VALUES ('m14230', '诺和灵30R笔芯', '注射剂', '诺和诺德（中国）制药有限公司', 63.30, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14231', '诺和灵N笔芯', '注射剂', '诺和诺德（中国）制药有限公司', 63.30, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14232', '诺和灵R笔芯', '注射剂', '诺和诺德（中国）制药有限公司', 63.30, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14233', '诺和锐30笔芯', '注射剂', '诺和诺德（中国）制药有限公司', 85.20, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14234', '诺和锐30特充', '注射剂', '诺和诺德（中国）制药有限公司', 100.00, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14235', '诺和锐笔芯', '注射剂', '诺和诺德（中国）制药有限公司', 85.20, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14236', '诺和锐特充', '注射剂', '诺和诺德（中国）制药有限公司', 100.00, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14237', '七氟烷注射液', '注射剂', '上海恒瑞医药有限公司', 991.00, '瓶', '100', '120ml', 0);
INSERT INTO `medicine` VALUES ('m14238', '前列地尔注射液', '注射剂', '哈药集团生物工程有限公司', 119.00, '支', '100', '10ug:2ml', 0);
INSERT INTO `medicine` VALUES ('m14239', '曲普瑞林注射液', '注射剂', 'Ferring AG', 137.00, '支', '100', '0.1mg:1ml', 0);
INSERT INTO `medicine` VALUES ('m14240', '神经节苷脂注射液(S)', '注射剂', 'JK齐鲁制药有限公司', 126.00, '支', '100', '20mg:2ml', 0);
INSERT INTO `medicine` VALUES ('m14241', '疏血通注射液', '注射剂', '牡丹江友博药业股份有限公司', 40.30, '支', '100', '2ml', 0);
INSERT INTO `medicine` VALUES ('m14242', '舒血宁注射液', '注射剂', '黑龙江珍宝岛药业股份有限公司', 20.70, '支', '100', '5ml', 0);
INSERT INTO `medicine` VALUES ('m14243', '缩宫素注射液(生物提取)', '注射剂', '安徽宏业药业有限公司', 13.00, '支', '100', '5U：1ml', 0);
INSERT INTO `medicine` VALUES ('m14244', '替罗非班氯化钠注射液', '注射剂', '远大医药（中国）有限公司', 358.00, '瓶', '100', '5mg:100ml', 0);
INSERT INTO `medicine` VALUES ('m14245', '天麻素注射液', '注射剂', '昆明制药集团股份有限公司', 20.70, '支', '100', '2ml', 0);
INSERT INTO `medicine` VALUES ('m14246', '托烷司琼注射液', '注射剂', '西南药业股份有限公司', 48.20, '支', '100', '2mg:2ml', 0);
INSERT INTO `medicine` VALUES ('m14247', '乌拉地尔注射液', '注射剂', '西安利君制药有限责任公司', 31.60, '支', '100', '25mg:5ml', 0);
INSERT INTO `medicine` VALUES ('m14248', '硝酸异山梨酯注射液(J)', '注射剂', '德国许瓦兹制药集团', 16.90, '支', '100', '10mg:10ml', 0);
INSERT INTO `medicine` VALUES ('m14249', '小儿复方氨基酸注射液', '注射剂', '天津金耀药业有限公司', 18.80, '支', '100', '20ml', 10);
INSERT INTO `medicine` VALUES ('m14250', '小牛血清去蛋白注射液', '注射剂', '锦州奥鸿药业有限责任公司', 46.10, '支', '100', '0.2g:5ml', 1);
INSERT INTO `medicine` VALUES ('m14251', '小牛血清去蛋白注射液', '注射剂', '锦州奥鸿药业有限责任公司', 78.30, '支', '100', '0.4g:10ml', 1);
INSERT INTO `medicine` VALUES ('m14252', '醒脑静注射液', '注射剂', '无锡济民可信山禾药业股份有限公司', 57.50, '支', '100', '10ml', 2);
INSERT INTO `medicine` VALUES ('m14253', '依达拉奉注射液', '注射剂', '南京先声东元制药有限公司', 46.00, '支', '100', '10mg:5ml', 4);
INSERT INTO `medicine` VALUES ('m14254', '依达拉奉注射液', '注射剂', '河北医科大学生物医学工程中心', 63.00, '支', '100', '30mg:20ml', 2);
INSERT INTO `medicine` VALUES ('m14255', '依托泊苷注射液', '注射剂', '江苏恒瑞医药股份有限公司', 13.80, '支', '100', '0.1g:5ml', 5);
INSERT INTO `medicine` VALUES ('m14256', '胰岛素注射液', '注射剂', '江苏万邦生化医药股份有限公司', 19.60, '支', '100', '400u:10ml', 3);
INSERT INTO `medicine` VALUES ('m14257', '银杏达莫注射液', '注射剂', '通化谷红制药有限公司', 25.30, '支', '100', '10ml', 2);
INSERT INTO `medicine` VALUES ('m14258', '荧光素钠注射液', '注射剂', '广西梧州制药(集团)股份有限公司', 92.00, '支', '100', '0.6g:3ml', 0);
INSERT INTO `medicine` VALUES ('m14259', '优泌乐50R笔芯', '注射剂', 'Lilly France S.A.S.', 85.20, '盒', '100', '300IU:3ml', 0);
INSERT INTO `medicine` VALUES ('m14260', '优泌林70/30笔芯', '注射剂', 'Lilly France', 63.30, '支', '100', '300IU:3ml', 0);
INSERT INTO `medicine` VALUES ('m14261', '优泌林R笔芯', '注射剂', 'Lilly France', 63.30, '支', '100', '300IU:3ml', 0);
INSERT INTO `medicine` VALUES ('m14262', '蔗糖铁注射液', '注射剂', '成都天台山制药有限公司', 64.50, '支', '100', '100mg：5ml', 0);
INSERT INTO `medicine` VALUES ('m14263', '脂溶性维生素注射液', '注射剂', '华瑞制药有限公司', 12.90, '支', '100', '10ml', 0);
INSERT INTO `medicine` VALUES ('m14264', '重组促卵泡素β注射液', '注射剂', 'N.V.Organon', 233.00, '支', '100', '50IU:0.5ML', 20);
INSERT INTO `medicine` VALUES ('m14265', '重组促卵泡素β注射液', '注射剂', 'N.V.Organon', 397.00, '支', '100', '100IU:0.5ml', 0);
INSERT INTO `medicine` VALUES ('m14266', '重组甘精胰岛素注射液', '注射剂', '甘李药业股份有限公司', 178.00, '支', '100', '300u:3ml', 0);
INSERT INTO `medicine` VALUES ('m14267', '重组人促红素注射液', '注射剂', '深圳赛保尔生物药业有限公司', 42.50, '支', '100', '4000U:1ml', 0);
INSERT INTO `medicine` VALUES ('m14268', '重组人粒细胞刺激因子注射液', '注射剂', '上海三维生物技术有限公司', 78.90, '支', '62', '150ug', 38);
INSERT INTO `medicine` VALUES ('m14269', '重组人粒细胞刺激因子注射液', '注射剂', '齐鲁制药有限公司', 122.00, '支', '100', '100 ug:0.6ml', 0);
INSERT INTO `medicine` VALUES ('m14270', '注射用阿莫西林钠克拉维酸钾', '注射剂', '华北制药股份有限公司', 21.00, '支', '100', '0.6g', 0);
INSERT INTO `medicine` VALUES ('m14271', '左卡尼汀注射液', '注射剂', '东北制药集团沈阳第一制药有限公司', 42.60, '支', '100', '1g:5ml', 0);
INSERT INTO `medicine` VALUES ('m14272', '左氧氟沙星氯化钠注射液', '注射剂', '浙江医药股份有限公司新昌制药厂', 39.80, '袋', '100', '0.3g:100ml', 0);
INSERT INTO `medicine` VALUES ('m14273', '30%脂肪乳注射液', '注射液', '西安力邦制药有限公司', 32.90, '瓶', '100', '30%:100ml', 0);
INSERT INTO `medicine` VALUES ('t0001', '测试', 'string', 'string', 0.00, 'string', 'string', 'string', 0);

-- ----------------------------
-- Table structure for medicine_histories
-- ----------------------------
DROP TABLE IF EXISTS `medicine_histories`;
CREATE TABLE `medicine_histories`  (
  `mrid` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用药记录',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `mid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `numb` int UNSIGNED NULL DEFAULT NULL,
  `orders` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `time` date NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`mrid`) USING BTREE,
  INDEX `fk_id_mr`(`patient_id` ASC) USING BTREE,
  INDEX `fk_rid_mr`(`patient_id` ASC) USING BTREE,
  INDEX `fk_mid`(`mid` ASC) USING BTREE,
  INDEX `medicine_hp`(`wid` ASC) USING BTREE,
  CONSTRAINT `medicine_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `medicine_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_medicine` FOREIGN KEY (`mid`) REFERENCES `medicine` (`mid`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1008 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medicine_histories
-- ----------------------------
INSERT INTO `medicine_histories` VALUES (1002, '123123123412341234', 'm13804', 1, '测试记录', '2025-02-06', NULL, 'w1025');
INSERT INTO `medicine_histories` VALUES (1003, '123123123412341234', 't0001', 0, '测试用', '2025-02-07', 'string', 'w10001');
INSERT INTO `medicine_histories` VALUES (1004, '123123123412341234', 'm13805', 12, '打算和1003开一个单子', '2025-02-07', NULL, 'w1026');
INSERT INTO `medicine_histories` VALUES (1005, '123123123412341234', 'm13808', 1, '给第一个case', '2025-02-07', NULL, NULL);
INSERT INTO `medicine_histories` VALUES (1006, '123123123412341234', 'm14047', NULL, '第二个', '2025-03-06', NULL, NULL);
INSERT INTO `medicine_histories` VALUES (1007, '123123123412341234', 'm13812', NULL, '2.2', '2025-02-20', NULL, NULL);

-- ----------------------------
-- Table structure for medicine_relationship
-- ----------------------------
DROP TABLE IF EXISTS `medicine_relationship`;
CREATE TABLE `medicine_relationship`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用药记录与门诊、住院、急救的关系',
  `mrid` int UNSIGNED NULL DEFAULT NULL,
  `record_id` int NULL DEFAULT NULL,
  `case_id` int NULL DEFAULT NULL,
  `operation_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `to_case`(`case_id` ASC) USING BTREE,
  INDEX `to_medicine_histories`(`mrid` ASC) USING BTREE,
  INDEX `to_record`(`record_id` ASC) USING BTREE,
  INDEX `to_operation`(`operation_id` ASC) USING BTREE,
  CONSTRAINT `to_case` FOREIGN KEY (`case_id`) REFERENCES `case_histories` (`case_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_medicine_histories` FOREIGN KEY (`mrid`) REFERENCES `medicine_histories` (`mrid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_operation` FOREIGN KEY (`operation_id`) REFERENCES `operation_histories` (`operation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_record` FOREIGN KEY (`record_id`) REFERENCES `medical_record` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medicine_relationship
-- ----------------------------
INSERT INTO `medicine_relationship` VALUES (1, 1002, 10025, NULL, NULL);
INSERT INTO `medicine_relationship` VALUES (2, 1003, 10027, NULL, NULL);
INSERT INTO `medicine_relationship` VALUES (3, 1004, 10027, NULL, NULL);
INSERT INTO `medicine_relationship` VALUES (4, 1005, NULL, 10301, NULL);
INSERT INTO `medicine_relationship` VALUES (5, 1006, NULL, 10302, NULL);
INSERT INTO `medicine_relationship` VALUES (6, 1007, NULL, 10302, NULL);

-- ----------------------------
-- Table structure for operation_histories
-- ----------------------------
DROP TABLE IF EXISTS `operation_histories`;
CREATE TABLE `operation_histories`  (
  `operation_id` int NOT NULL AUTO_INCREMENT COMMENT '急救用表',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `informant` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供史者 本人/亲属/目击者',
  `scene_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '现场地址',
  `dispatch_time` datetime NULL DEFAULT NULL COMMENT '出车时间',
  `arrival_on_scene_time` datetime NULL DEFAULT NULL COMMENT '到达现场时间',
  `departure_from_scene_time` datetime NULL DEFAULT NULL COMMENT '离开现场时间',
  `arrival_at_hospital_time` datetime NULL DEFAULT NULL COMMENT '到达医院时间\r\n',
  `destination` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '送达地',
  `severity_level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '病情分级',
  `emergency_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '急救性质 院前急救/转院/其他',
  `chief_complaint` blob NULL COMMENT '病史/主诉',
  `initial_diagnosis` blob NULL COMMENT '初步诊断',
  `procedures` blob NULL COMMENT '急救处理，有就记录，看表',
  `medicine` blob NULL COMMENT '药物使用记录',
  `outcome` blob NULL COMMENT '急救结果',
  `physician` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '急救医师（写名字吧，实在是懒得filter wid）',
  `nurse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '护士',
  `driver` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '司机',
  `paramedic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '抢救员',
  `stretcher_bearer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '担架工',
  `recipient` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '院内接收者',
  `initial_eid` int NULL DEFAULT NULL COMMENT '初检id',
  `final_eid` int NULL DEFAULT NULL COMMENT '终检id',
  `ti_score` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创伤指数评分',
  `ti_content` json NULL COMMENT 'ti具体内容，参考表格\r\n',
  `gcs_score` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'gcs评分',
  `gcs_content` json NULL COMMENT 'gcs具体内容',
  `Killip_score` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Killip分级',
  `Killip_content` json NULL COMMENT '表格里的胸痛高位状态评估',
  `Killip_diagnosis` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '胸痛初步判断',
  `cerebral_stroke_content` json NULL COMMENT '脑卒中评估',
  PRIMARY KEY (`operation_id`) USING BTREE,
  INDEX `operation_patient`(`patient_id` ASC) USING BTREE,
  INDEX `final_exam`(`final_eid` ASC) USING BTREE,
  INDEX `initial_exam`(`initial_eid` ASC) USING BTREE,
  CONSTRAINT `final_exam` FOREIGN KEY (`final_eid`) REFERENCES `basic_check` (`eid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `initial_exam` FOREIGN KEY (`initial_eid`) REFERENCES `basic_check` (`eid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `operation_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 20246 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_histories
-- ----------------------------
INSERT INTO `operation_histories` VALUES (20202, '123123123412341234', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '院前急救', 0x737472696E67, 0x737472696E67, 0x737472696E67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '13', '{\"circulation\": \"收缩压 70~100\", \"injury_site\": \"四肢\", \"injury_type\": \"挫伤\", \"respiration\": \"呼吸困难\", \"consciousness\": \"恍惚\", \"circulation_score\": 3, \"injury_site_score\": 1, \"injury_type_score\": 3, \"respiration_score\": 3, \"consciousness_score\": 3}', 'GCS 10 + T = E4 + VT + M6 at 18:58', '{\"gcs_e\": \"自发\", \"gcs_m\": \"执行口令\", \"gcs_v\": \"气管因素\", \"gcs_e_score\": 4, \"gcs_m_score\": 6, \"gcs_v_score\": \"T\"}', 'Killip II', '{\"highRisk\": [\"持续性胸闷/胸痛\", \"腹痛\", \"心衰\", \"休克\", \"恶性心律失常\", \"其它\"], \"otherHighRisk\": \"1231231\"}', '急性心肌梗死ok', '{\"other\": \"\", \"selected\": [\"面部不对称(F)\", \"上肢无力(A)\"]}');
INSERT INTO `operation_histories` VALUES (20204, '123456123112311231', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 12001, 12002, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20206, '123123123412341234', '本人', '翻斗花园小区', '2025-02-08 08:39:03', '2025-02-08 08:39:03', '2025-02-08 08:39:03', '2025-02-08 08:39:03', '人民医院', '1级', '院前急救', 0xE4B88AE78FADE4B88AE7B4AFE4BA86, 0xE99C80E8A681E4B88BE78FAD, 0xE697A0, 0xE69C8DE794A86B6F69E6B586E69E9CE985A5E985AAE5A5B6E88CB6E4B880E4BBBD, 0xE6988EE5A4A9E591A8E697A5E5B0B1E883BDE6B4BBE4BA86, '渥子集', '无', '斡梓级', '无', '无', '无', NULL, NULL, '无', NULL, 'string', NULL, 'string', NULL, 'string', NULL);
INSERT INTO `operation_histories` VALUES (20207, '123123123412341234', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0x706174636855706461746554657374, NULL, 0x737472696E67, 0x746573743233, 0x737472696E67, 'string', 'string', 'string', '1234341', 'string', 'string', 12001, 12002, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20216, '123123123412341234', 'string', 'string', '2025-02-12 10:36:15', '2025-02-12 10:36:15', '2025-02-12 10:36:15', '2025-02-12 10:36:15', 'string', 'string', 'string', 0x737472696E67, 0x737472696E67, 0x737472696E67, 0x737472696E67, 0x737472696E67, 'string', 'string', 'string', 'string', 'string', 'string', NULL, NULL, 'string', NULL, 'string', NULL, 'string', NULL, 'string', NULL);
INSERT INTO `operation_histories` VALUES (20237, '123123123412341234', '本人', 'filled', '2025-02-17 02:27:45', NULL, NULL, NULL, '第一人民医院', 'Ⅳ级（非急症）', '转院', 0xE697A0, NULL, NULL, NULL, NULL, '缑安雁', '籍觅珍', '周所龄', '', '', NULL, 12003, 12004, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20238, '123123200308281234', '本人', '白玉兰广场', '2025-02-19 10:21:32', '2025-02-19 10:21:32', '2025-02-19 10:21:32', '2025-02-19 10:21:32', '人民医院', 'Ⅳ级（非急症）', '院前急救', 0xE5BF83E7B4AF3268EFBC8CE5969DE5A5B6E88CB6E4B88DE883BDE5A5BDE8BDACE38082, 0xE4B88AE78FADE4B88AE79A84, 0xE9809FE9809FE4B88BE78FADE59B9EE5AEB6E8BABAE59CA8E5BA8AE4B88AE5B0B1E5A5BDE4BA86, 0xE99CB8E78E8BE88CB6E5A7ACEFBC8C6B6F69EFBC8CE88C89E88E89E5A5B6E799BD, 0xE8BF98E6B2A1E4B88BE78FAD, '张三', '李四', '王五', '赵六', '钱八', '陈九', 12006, 12005, 'string', NULL, 'string', NULL, 'string', NULL, 'string', NULL);
INSERT INTO `operation_histories` VALUES (20239, NULL, '', '', '2025-02-20 12:46:18', NULL, NULL, NULL, '', '', '', '', NULL, NULL, NULL, NULL, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20240, NULL, '', '', '2025-02-20 12:55:14', NULL, NULL, NULL, '', '', '', '', NULL, NULL, NULL, NULL, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20241, '123123123412341234', '', '', '2025-02-20 13:01:45', NULL, NULL, NULL, '', '', '', '', NULL, NULL, NULL, NULL, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20242, '123123123412341234', '', '', '2025-02-20 13:03:28', NULL, NULL, NULL, '', '', '', '', NULL, NULL, NULL, NULL, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20243, NULL, '', '', '2025-02-20 13:10:37', '2025-02-20 13:11:21', '2025-02-20 13:11:41', '2025-02-20 13:11:59', '', '', '', '', NULL, NULL, NULL, NULL, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20244, '123123123412341234', '本人', '', '2025-02-20 13:25:11', NULL, NULL, NULL, '', '', '', '', NULL, NULL, NULL, NULL, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `operation_histories` VALUES (20245, '123123123412341234', '本人', '现场', '2025-02-26 03:31:18', '2025-02-26 03:31:46', '2025-02-26 03:33:19', '2025-02-26 03:33:19', '', 'Ⅳ级（非急症）', '院前急救', 0xE697A03132333132333132, NULL, NULL, NULL, NULL, '', '', '阮新巧', '', '', NULL, 12007, 12008, '18', '{\"circulation\": \"正常\", \"injury_site\": \"其他\", \"injury_type\": \"其他\", \"respiration\": \"正常\", \"consciousness\": \"清醒\", \"circulation_score\": 5, \"injury_site_score\": 1, \"injury_type_score\": 2, \"respiration_score\": 5, \"consciousness_score\": 5}', NULL, 'null', NULL, 'null', NULL, NULL);

-- ----------------------------
-- Table structure for operation_relating
-- ----------------------------
DROP TABLE IF EXISTS `operation_relating`;
CREATE TABLE `operation_relating`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '急救相关人员信息记录',
  `operation_id` int NULL DEFAULT NULL,
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `timestamp` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `operation_hp`(`wid` ASC) USING BTREE,
  INDEX `to_operationhis`(`operation_id` ASC) USING BTREE,
  CONSTRAINT `operation_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_operationhis` FOREIGN KEY (`operation_id`) REFERENCES `operation_histories` (`operation_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_relating
-- ----------------------------

-- ----------------------------
-- Table structure for patient
-- ----------------------------
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient`  (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `idType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `telno` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ethnicity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`patient_id`) USING BTREE,
  INDEX `patient_id`(`patient_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of patient
-- ----------------------------
INSERT INTO `patient` VALUES ('NA', 'NA', '护照', 'NA', 'NA', 'NA', '123123000000000000');
INSERT INTO `patient` VALUES ('张三', '男', '身份证', '12312312312', '测试用户', '汉族', '123123123412341234');
INSERT INTO `patient` VALUES ('乐', '女', '身份证', '15151799630', '白玉兰广场', '汉', '123123200308281234');
INSERT INTO `patient` VALUES ('测试0', '男', '身份证', '12312312312', '无', '无', '123456123112311231');
INSERT INTO `patient` VALUES ('Mark', 'male', '身份证', '12345678912', 'string', 'string', '789789200101251234');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (2, '??', 'lisi@example.com');
INSERT INTO `users` VALUES (3, '??', 'wangwu@example.com');
INSERT INTO `users` VALUES (4, 'testtest', 'testtest@unity.cn');
INSERT INTO `users` VALUES (5, '1232313', '2463955195@qq.com');

SET FOREIGN_KEY_CHECKS = 1;
