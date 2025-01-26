-- MySQL dump 10.13  Distrib 9.1.0, for Win64 (x86_64)
--
-- Host: localhost    Database: AmbuSmart
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `AmbuSmart`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `AmbuSmart` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `AmbuSmart`;

--
-- Table structure for table `allergies`
--

DROP TABLE IF EXISTS `allergies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allergies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` varchar(255) NOT NULL,
  `allergy_name` varchar(255) DEFAULT NULL,
  `severity` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `from_patientid` (`patient_id`) USING BTREE,
  CONSTRAINT `from_patientid` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allergies`
--

LOCK TABLES `allergies` WRITE;
/*!40000 ALTER TABLE `allergies` DISABLE KEYS */;
INSERT INTO `allergies` VALUES (1,'123123123412341234','Pollen','Moderate','Seasonal allergy, primarily in spring'),(2,'123123123412341234','Peanuts','Severe','Anaphylactic reaction, requires immediate medical attention');
/*!40000 ALTER TABLE `allergies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ambulance`
--

DROP TABLE IF EXISTS `ambulance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ambulance` (
  `aid` int NOT NULL COMMENT '给救护车的一个表',
  `car_num` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ambulance`
--

LOCK TABLES `ambulance` WRITE;
/*!40000 ALTER TABLE `ambulance` DISABLE KEYS */;
/*!40000 ALTER TABLE `ambulance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_histories`
--

DROP TABLE IF EXISTS `case_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `case_histories` (
  `case_id` int NOT NULL AUTO_INCREMENT COMMENT '住院单，已剔除check',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '门诊医师',
  `dno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `hospital` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `in_timestamp` datetime DEFAULT NULL COMMENT '入院时间',
  `out_timestamp` datetime DEFAULT NULL COMMENT '出院时间',
  `in_assessment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '入院病情',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `out_result` varchar(255) DEFAULT NULL COMMENT '出院诊断',
  PRIMARY KEY (`case_id`) USING BTREE,
  KEY `from_patientid` (`patient_id`) USING BTREE,
  KEY `from_wid` (`wid`) USING BTREE,
  KEY `med_department` (`dno`) USING BTREE,
  CONSTRAINT `case_department` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `case_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `case_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10301 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_histories`
--

LOCK TABLES `case_histories` WRITE;
/*!40000 ALTER TABLE `case_histories` DISABLE KEYS */;
INSERT INTO `case_histories` VALUES (10300,'123123123412341234',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `case_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `check`
--

DROP TABLE IF EXISTS `check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check` (
  `cid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `place` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `device` varchar(255) DEFAULT NULL,
  `num` int unsigned DEFAULT '0',
  PRIMARY KEY (`cid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check`
--

LOCK TABLES `check` WRITE;
/*!40000 ALTER TABLE `check` DISABLE KEYS */;
INSERT INTO `check` VALUES ('h1','尿肌红蛋白定性检查','临床化验科',4.00,'24hUTP',11),('h2','尿血红蛋白定性检查','临床化验科',2.00,NULL,1),('h3','局部切取组织活检检查与诊断','临床化验科',150.00,NULL,0),('h4','免疫球蛋白IgA定量测定','临床化验科',10.00,NULL,0),('h5','免疫组织化学染色诊断','临床化验科',109.00,NULL,0),('h6','淋巴细胞免疫分析','临床化验科',30.00,NULL,0),('h7','胸腹水常规检查','临床化验科',3.00,NULL,5),('m1','针刺找过敏原（1组）','临床免疫科',20.00,NULL,0),('m2','针刺找过敏原（≥2组）','临床免疫科',40.00,NULL,0),('m3','免疫缺陷病毒(HIV)抗原抗体联合检测','临床免疫科',30.00,NULL,1),('n1','关节镜检查','内镜科',200.00,NULL,0),('n10','直肠镜检查','内镜科',40.00,NULL,0),('n11','胸腔镜检查','内镜科',200.00,NULL,1),('n2','内镜组织活检检查与诊断','内镜科',109.00,NULL,0),('n3','小肠镜检查','内镜科',470.00,NULL,0),('n4','食管镜检查','内镜科',50.00,NULL,0),('n5','鼻内镜检查','内镜科',3.00,NULL,0),('n6','腹腔镜检查','内镜科',300.00,NULL,0),('n7','膀胱镜尿道镜检查','内镜科',180.00,NULL,0),('n8','肛门镜检查','内镜科',20.00,NULL,0),('n9','结肠镜检查','内镜科',400.00,NULL,0),('t1','三棱镜检查','眼科',5.00,NULL,0),('t10','视网膜视力检查','眼科',5.00,NULL,1),('t11','眼科常规检查','眼科',5.00,NULL,3),('t12','甲状腺功能常规检查','普通内科',125.00,NULL,0),('t13','肝功能常规检查','普通内科',31.00,NULL,0),('t14','牙周常规检查','牙科',1.00,NULL,0),('t15','肾功能常规检查','普通内科',12.00,NULL,0),('t16','肛门指检','普通内科',3.00,NULL,0),('t17','特殊视力检查','眼科',2.00,NULL,0),('t2','上睑下垂检查','眼科',2.00,NULL,0),('t3','义齿压痛定位仪检查','牙科',1.00,NULL,0),('t4','口腔常规检查','牙科',5.00,NULL,0),('t5','喉动态镜检查','耳鼻喉科',50.00,NULL,0),('t6','妇科常规检查','妇科',13.00,NULL,0),('t7','常规心电图检查','普通内科',20.00,NULL,0),('t8','面神经肌电图检查','普通内科',20.00,NULL,0),('t9','角膜刮片检查（单眼）','眼科',10.00,NULL,0),('w1','一般细菌涂片检查','临床微生物科',5.00,NULL,1),('w10','异常红细胞形态检查','临床微生物科',1.00,NULL,0),('w11','淋巴细胞免疫分析','临床微生物科',30.00,NULL,0),('w2','内窥镜刷片脱落细胞学检查与诊断','临床微生物科',55.00,NULL,0),('w3','囊肿穿刺液细胞学检查与诊断','临床微生物科',39.00,NULL,0),('w4','子宫内膜脱落细胞学检查与诊断','临床微生物科',55.00,NULL,0),('w5','结核菌涂片检查','临床微生物科',8.00,NULL,0),('w6','巨噬细胞吞噬功能试验','临床微生物科',10.00,NULL,0),('w7','外周血淋巴细胞微核试验','临床微生物科',280.00,NULL,0),('w8','抗体依赖性细胞毒性试验','临床微生物科',15.00,NULL,0),('w9','快速细胞病理诊断','临床微生物科',105.00,NULL,0),('x1','凝血功能常规检查','血液科',48.00,NULL,0),('x10','病毒血清学试验','血液科',20.00,NULL,1),('x2','血清渗透压检查','血液科',10.00,NULL,0),('x3','血细胞染色体检查','血液科',39.00,NULL,0),('x4','血脂常规检查','血液科',19.00,NULL,0),('x5','血清过敏原特异IgG测定','血液科',10.00,NULL,0),('x6','ABO血型鉴定','血液科',8.00,NULL,0),('x7','血型抗原鉴定','血液科',15.00,NULL,0),('x8','冷溶血试验','血液科',4.00,NULL,0),('x9','快速血浆反应素试验(RPR)','血液科',5.00,NULL,0),('y1','CT增强扫描(一个部位)','医学影像科',140.00,'西门子128排螺旋CT',0),('y10','胎儿系统彩色多普勒超声检查','医学影像科',270.00,NULL,0),('y2','CT平扫(一个部位)','医学影像科',80.00,'西门子128排螺旋CT',0),('y3','磁共振扫描MRI','医学影像科',500.00,'GE Discovery MR750 3.0T研究型磁共振成像仪',0),('y4','PET/MR 局部显像','医学影像科',6600.00,'飞利浦GEMINI TF PET/CT系统',0),('y5','PET/MR 全身显像','医学影像科',11000.00,'飞利浦GEMINI TF PET/CT系统',0),('y6','A型超声检查(一个部位)','医学影像科',2.00,NULL,0),('y7','B超常规检查(一个部位)','医学影像科',15.00,NULL,0),('y8','B超检查（孕、环情）','医学影像科',5.00,NULL,0),('y9','彩色多普勒超声常规检查(一个部位)','医学影像科',70.00,NULL,0);
/*!40000 ALTER TABLE `check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `check_histories`
--

DROP TABLE IF EXISTS `check_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check_histories` (
  `check_id` int NOT NULL AUTO_INCREMENT COMMENT '检查信息，仅做内容，不考虑实际记录',
  `patient_id` varchar(255) NOT NULL,
  `wid` varchar(255) DEFAULT NULL COMMENT '操作人员工号',
  `timestamp` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `result` blob,
  `description` blob,
  `cid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`check_id`) USING BTREE,
  KEY `from_patientid` (`patient_id`) USING BTREE,
  KEY `from_wid` (`wid`) USING BTREE,
  KEY `to_checklist` (`cid`),
  CONSTRAINT `check_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_checklist` FOREIGN KEY (`cid`) REFERENCES `check` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check_histories`
--

LOCK TABLES `check_histories` WRITE;
/*!40000 ALTER TABLE `check_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `check_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `check_relationship`
--

DROP TABLE IF EXISTS `check_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check_relationship` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用于记录检查和门诊/住院/急救的关系',
  `record_id` int DEFAULT '10010',
  `case_id` int DEFAULT '10300',
  `operation_id` int DEFAULT '20202' COMMENT '急救用',
  `check_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `check_recordmed` (`record_id`),
  KEY `check_case` (`case_id`),
  KEY `to_check` (`check_id`),
  KEY `check_operation` (`operation_id`),
  CONSTRAINT `check_case` FOREIGN KEY (`case_id`) REFERENCES `case_histories` (`case_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_operation` FOREIGN KEY (`operation_id`) REFERENCES `operation_histories` (`operation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_recordmed` FOREIGN KEY (`record_id`) REFERENCES `medical_record` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_check` FOREIGN KEY (`check_id`) REFERENCES `check_histories` (`check_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check_relationship`
--

LOCK TABLES `check_relationship` WRITE;
/*!40000 ALTER TABLE `check_relationship` DISABLE KEYS */;
/*!40000 ALTER TABLE `check_relationship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `dno` varchar(255) NOT NULL,
  `dname` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES ('b1','耳鼻喉科','耳鼻喉科'),('e1','儿科','儿科'),('f1','妇科','妇产科'),('f2','产科','妇产科'),('g1','骨科','骨科'),('g2','骨科（创伤）','骨科'),('j1','血液科','部门'),('j2','医学影像科','部门'),('j3','体外检查科','部门'),('j4','临床化验科','部门'),('j5','临床免疫科','部门'),('j6','临床微生物科','部门'),('j7','内镜科','部门'),('k1','口腔科','口腔科'),('n1','普通内科','内科'),('n2','血液内科','内科'),('n3','风湿免疫科','内科'),('n4','心血管内科','内科'),('n5','呼吸与危重症医学科','内科'),('n6','内分泌代谢科','内科'),('n7','消化内科','内科'),('n8','肾内科','内科'),('n9','内分泌科','内科'),('p1','皮肤科','皮肤科'),('w1','普通外科','外科'),('w2','特诊外科','外科'),('w3','神经外科','外科'),('w4','泌尿外科','外科'),('w5','胸心外科','外科'),('w6','整形科','外科'),('w7','甲状腺外科','外科'),('w8','乳腺外科','外科'),('y1','眼科','眼科'),('z1','肿瘤科','肿瘤科'),('zy1','中医内科','中医科'),('zy2','中医针灸科','中医科'),('zy3','中医伤科','中医科');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_personnel`
--

DROP TABLE IF EXISTS `health_personnel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_personnel` (
  `wid` varchar(255) NOT NULL,
  `dno` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `job` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`wid`),
  KEY `dno` (`dno`,`wid`),
  KEY `dno_2` (`dno`,`wid`,`name`),
  KEY `job` (`job`,`wid`),
  KEY `wid` (`wid`,`job`,`dno`),
  KEY `hp2` (`wid`,`dno`,`name`),
  CONSTRAINT `health_personnel_ibfk_1` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_personnel`
--

LOCK TABLES `health_personnel` WRITE;
/*!40000 ALTER TABLE `health_personnel` DISABLE KEYS */;
INSERT INTO `health_personnel` VALUES ('w10001','g1','田柾国','医生','男','123456199709011234',25),('w1023','b1','钟如妙','医生','男','220281199502038962',28),('w1024','b1','幸葵樱','副高','女','469021197902212545',44),('w1025','b1','倪楷准','正高','男','130926194709277323',75),('w1026','b1','司涓娟','精英','女','140781198307111440',40),('w1027','b1','经华晔','医生','男','130284198711145083',35),('w1028','e1','萧延高','医生','男','640221198809254600',34),('w1029','e1','怀歆珣','医生','男','360830198404107705',39),('w1030','e1','滑嵘红','正高','女','370685197502106617',48),('w1031','e1','计胤翔','精英','男','330213197608250480',47),('w1032','e1','张延旗','医生','女','63272319291229447X',93),('w1033','e1','詹连野','医生','男','361103195202293762',71),('w1034','f1','姜沫蒙','医生','女','13028319761117353X',46),('w1035','f1','邴鹰品','医生','男','510725199709040963',25),('w1036','f1','窦方纲','副高','女','411121198704235934',36),('w1037','f1','贡可亚','副高','男','520628200104210617',22),('w1038','f2','常一泉','医生','女','220523199202216760',31),('w1039','f2','史桦汉','正高','男','621121198301078136',40),('w1040','f2','仰泉璋','精英','女','130207200109055461',22),('w1041','f2','田卉巧','精英','男','421002198612299102',36),('w1042','g1','祖梓展','精英','男','410781199905289819',24),('w1043','g1','顾普彬','副高','女','150603199107233695',32),('w1044','g1','樊耘栋','医生','男','530828200112222717',21),('w1045','g1','宗萍言','副高','女','632821198704010369',36),('w1046','g2','缪慈春','精英','男','420324192403280129',99),('w1047','g2','白蔷霁','精英','女','441521197710029291',45),('w1048','g2','包曼睿','医生','男','610803197806280717',45),('w1049','k1','杭前然','医生','男','440705199209046273',30),('w1050','k1','怀靖闽','副高','男','360313198904231079',34),('w1051','k1','卓京品','正高','女','360726197612318286',46),('w1052','k1','万微洵','精英','男','341322200312095142',19),('w1053','n1','胡晓寒','医生','女','45102219680428429X',55),('w1054','n1','乌通赞','医生','男','230805197008310955',52),('w1055','n1','汪梦游','医生','女','53332319850725237X',38),('w1056','n1','陈霁珠','医生','男','510823198407123729',39),('w1057','n1','江绚姣','医生','女','513422198506293971',38),('w1058','n1','束玮彬','副高','男','411481197302054322',40),('w1059','n1','马诚漫','医生','女','150927196304298416',60),('w1060','n1','严通寒','正高','男','210204197107166543',52),('w1061','n1','富庆令','精英','女','654022196309176574',59),('w1062','n2','俞逸华','精英','男','13082119800918205X',42),('w1063','n2','孟力田','精英','男','211421193412177804',88),('w1064','n2','汪贞艳','副高','女','350423200905103745',14),('w1065','n2','陈铖曙','医生','男','420322196011036181',62),('w1066','n3','胡茉惠','副高','女','410205194412094953',78),('w1067','n3','汤岚卿','正高','男','130981201004243921',13),('w1068','n3','宫巧嫒','精英','女','510115194306214406',80),('w1069','n3','崔弘泽','医生','男','130408196709230671',55),('w1070','n3','邓春蔷','医生','女','360402198604076610',37),('w1071','n4','孟莹或','医生','男','370105191963126997',54),('w1072','n4','齐知蓓','医生','女','371423201306079965',10),('w1073','n4','强丽予','副高','男','511525197407060570',49),('w1074','n4','蒙庚淼','副高','女','411381198401141288',39),('w1075','n4','舒咏舟','医生','男','150523200310224757',19),('w1076','n5','樊灵葵','正高','女','610328191609039898',106),('w1077','n5','梅晋州','精英','男','420205201103264378',12),('w1078','n5','白婕冶','精英','男','520627197808248823',44),('w1079','n5','马珣果','精英','女','150429194803214746',75),('w1080','n5','管向昌','副高','男','421124201301159100',10),('w1081','n6','裴纪韵','医生','女','410411191511022810',107),('w1082','n6','蓬韶铖','副高','男','511421191001257190',113),('w1083','n6','舒韵珍','正高','男','500115198502144237',38),('w1084','n7','孔郁懿','精英','女','15042819950719461X',28),('w1085','n7','孙欣霁','医生','男','370682196903267215',54),('w1086','n7','贺云妮','医生','女','622927199705301899',26),('w1087','n7','马杉韶','副高','男','130725199709158952',25),('w1088','n7','郁前旗','正高','男','230505191205062720',111),('w1089','n8','单广润','精英','男','140215201304208298',10),('w1090','n8','方珑爱','医生','女','430181190905270990',114),('w1091','n8','吉起嵘','医生','男','220503191505090577',108),('w1092','n8','戴年纲','医生','女','330902197702067403',46),('w1093','n9','单帅丛','医生','男','440310190402060518',119),('w1094','n9','姜河孝','副高','女','150624201302146900',10),('w1095','n9','胡蕴旖','副高','男','130928194807035806',75),('w1096','n9','罗雷年','医生','女','510321193006209035',93),('w1097','p1','彭驰竹','正高','男','450502195810098537',64),('w1098','p1','尹如晓','精英','女','410302191905212244',104),('w1099','p1','苏倩悦','医生','男','430482201107021766',12),('w1100','p1','孙隽华','副高','女','320106201412146460',8),('w1101','w1','杨珩融','正高','男','152526193705297326',86),('w1102','w1','田艺建','精英','男','210624199602205892',27),('w1103','w1','白燕纯','医生','女','511603194102272076',82),('w1104','w1','韦栋澄','医生','男','445203198210123870',40),('w1105','w1','单罡凯','医生','女','45020419850417807X',38),('w1106','w1','芮升纲','医生','男','370602195107173828',72),('w1107','w1','葛耀铮','副高','女','220781192807172636',95),('w1108','w2','鲍千展','副高','男','621027192202244800',101),('w1109','w2','嵇喆格','医生','男','53292319560116496X',67),('w1110','w2','滑彩怡','正高','男','451424200301104262',20),('w1111','w3','宁琚兰','精英','女','340621196402271218',59),('w1112','w3','邬筝乐','精英','男','510821195803080365',65),('w1113','w3','毕舟立','精英','女','230307199610091179',26),('w1114','w3','滕芊振','副高','男','654025191307183523',110),('w1115','w4','伏依艳','医生','女','530129194308070946',80),('w1116','w4','左影真','副高','男','430281194706295662',76),('w1117','w4','邢予煦','正高','女','411526190506083383',118),('w1118','w5','娄莉妲','精英','男','150221200411297518',18),('w1119','w5','凤琛起','医生','女','640324199902043796',24),('w1120','w5','韦鹭婧','医生','男','370213193901097584',84),('w1121','w5','宁佩晔','副高','女','140303192806228625',95),('w1122','w5','章星情','正高','男','410702193509121384',87),('w1123','w6','虞歌硕','精英','男','620121190507112195',118),('w1124','w6','齐瑾怀','医生','女','410182191705263830',106),('w1125','w6','解芬涓','医生','男','210803196811173909',54),('w1126','w7','房辰旖','医生','女','370827194111187759',81),('w1127','w7','任焘蔚','医生','男','21010619820705898X',41),('w1128','w7','马文晓','副高','女','430623190907205213',114),('w1129','w7','左中崧','副高','男','53090219501030172X',72),('w1130','w8','童齐克','医生','女','230723191601079587',107),('w1131','w8','符博原','副高','男','370306195912206417',63),('w1132','w8','马澄翌','正高','女','440802193812228273',84),('w1133','y1','纪劲朴','精英','男','361102191001313929',113),('w1134','y1','乔馨凡','医生','女','130205200004152158',23),('w1135','y1','蒙严信','医生','男','15012219561214673X',66),('w1136','y1','娄能格','医生','女','150103195207024633',71),('w1137','y1','虞涌默','医生','男','211224200307025703',20),('w1138','y1','韶羽耿','副高','男','510725196511221626',57),('w1139','j1','贺韬遥','副高','女','522326200403268168',19),('w1140','j1','水岩勉','医生','男','350322194002054719',83),('w1141','j1','井孝辰','医生','男','130207194508184748',77),('w1142','j1','郜傲奕','精英','女','420303198805249410',35),('w1143','z1','黄斐莉','正高','男','140223200705101737',16),('w1144','z1','单添红','精英','男','440105199902036775',24),('w1145','z1','龙沁妮','副高','男','370684191905303849',104),('w1146','z1','符金渝','医生','女','620121190310271862',119),('w1147','zy1','汪奇栋','副高','男','632726197707048466',46),('w1148','zy1','缪溢昌','正高','女','440512193205309262',91),('w1149','zy1','祝闽坦','精英','男','340826199403184198',29),('w1150','zy1','邢允文','医生','女','32098119110817523X',111),('w1151','zy1','黄严帆','医生','男','330205192807288892',95),('w1152','zy2','吕雍琼','副高','女','220202199712205940',25),('w1153','zy2','秋琴栋','正高','男','360821199411239170',28),('w1154','zy2','咎弘璋','精英','女','130321193904034934',84),('w1155','zy2','程俐璇','医生','男','53282319161129254X',106),('w1156','zy2','龚珍安','医生','女','152529199911037134',23),('w1157','zy2','宋垒辉','医生','男','350702197508106694',48),('w1158','zy2','翁玉蓉','医生','男','130435194503097019',78),('w1159','j2','潘祺余','副高','女','140724196706077198',56),('w1160','j2','史畅秀','副高','男','420525200003082400',23),('w1161','j2','郦琼赢','医生','女','530621200004093836',23),('w1162','j2','林唯诗','正高','男','37078219951003847X',27),('w1163','j2','严章郁','精英','女','469006191107046129',112),('w1164','j2','缪蝶蝶','副高','男','231124196409200946',58),('w1165','j3','陆严澎','医生','男','421123197207139570',51),('w1166','j3','冯渝莹','医生','男','130632199907014456',24),('w1167','j3','张垚远','医生','女','23122420210120897X',2),('w1168','j3','侯琼炯','医生','男','150121193908090856',84),('w1169','j3','平铃舟','副高','女','511827193105091649',92),('w1170','j3','支钊淮','副高','男','330902196404226758',59),('w1171','j4','龙育冕','医生','女','445303197202160250',51),('w1172','j4','陈淳翔','副高','男','140405197702152284',46),('w1173','j4','宫克红','正高','女','520330202011128467',2),('w1174','j4','郁娜芬','精英','男','450981196603140845',57),('w1175','j4','沈暖妹','医生','女','131121200702162359',16),('w1176','j4','苏洋胡','医生','男','230382198705278492',36),('w1177','j5','惠臣柱','医生','女','510623194802194675',75),('w1178','j5','谢蔷琪','医生','男','150102200708289354',15),('w1179','j5','明钥韵','副高','男','430723193601041075',87),('w1180','j5','周芳晨','副高','女','540122191008232417',112),('w1181','j5','谭硕舟','医生','男','610324201302117776',10),('w1182','j5','毛琳甜','正高','女','37021519380428839X',85),('w1183','j5','幸振忆','精英','男','44152120070515368X',16),('w1184','j5','夏建飚','精英','女','371083190407074454',119),('w1185','j6','鲁妃星','精英','男','410181190311277227',119),('w1186','j6','甄煦可','副高','女','42032519770707477X',46),('w1187','j6','袁沙楚','医生','男','610327201509079040',7),('w1188','j6','龙霆韬','副高','女','320921197407219846',49),('w1189','j6','叶友勋','正高','男','513327196302189563',60),('w1190','j6','咎研亚','精英','女','140927193011290992',92),('w1191','j6','韶绚樱','医生','男','130204192602280965',97),('w1192','j7','韩艾心','医生','女','360724195710158675',65),('w1193','j7','黎卉晔','副高','男','130105200203239867',21),('w1194','j7','伊屹盼','正高','男','210904200503192148',18),('w1195','j7','潘蔷芬','精英','女','422828196312237857',59),('w1196','j7','金花言','医生','男','320681192802080829',95),('w1197','j7','邱纯默','医生','女','430529190410211821',118),('w1198','j7','张嫒晓','医生','男','46902719251231068X',97),('w1199','g2','杨羽旋','医生','男','50023819170806015X',106),('w1200','g2','咎奕咪','副高','女','150207194010126675',82),('w1201','g2','鲍璇朗','副高','男','451003193505086282',88),('w1202','n1','姚懿青','医生','女','231281197107116383',52),('w1203','n1','苏娓蓉','正高','男','42052719790112085X',44),('w1204','n1','蔡衡方','精英','男','511129194010202552',82),('w1205','n2','怀含颜','副高','男','511126195708042031',66),('w1206','n2','秋正锁','医生','女','360402193503123484',88),('w1207','n2','虞怡芮','医生','男','440507196707086460',56),('w1208','w3','程笛奇','医生','女','210104198712272482',35),('w1209','w3','殷舟钊','医生','男','350982192101309692',102),('w1210','w3','黄钧瑛','副高','女','210882190801310955',115),('w1211','w3','殷鸿韵','副高','男','513435199201011159',31),('w1212','w7','范钰侃','医生','女','511112199608099858',27),('w1213','w7','薛义年','副高','男','530927201006010108',13),('w1214','w7','殷咏日','正高','女','451122197103083065',52),('w1215','y1','邴好歆','精英','男','211281199602231069',27),('w1216','y1','凤乾月','医生','女','530303194001029903',83),('w1217','y1','毛林或','医生','男','371103196504211570',58),('w1218','y1','成璐秀','医生','男','210402198910212644',33),('w1219','k1','庞菲芊','医生','女','650521200502190497',18),('w1220','k1','卓研浩','副高','男','440118199712094335',25),('w1221','k1','姬昆佳','医生','女','420607190401072482',119),('w1222','k1','莫珊辰','医生','男','330305195402057104',69);
/*!40000 ALTER TABLE `health_personnel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_histories`
--

DROP TABLE IF EXISTS `medical_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_histories` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '既往史',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `condition_name` varchar(255) DEFAULT NULL,
  `diagnosis_date` date DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `from_patientid` (`patient_id`) USING BTREE,
  CONSTRAINT `hisfrom_patientid` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_histories`
--

LOCK TABLES `medical_histories` WRITE;
/*!40000 ALTER TABLE `medical_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_record`
--

DROP TABLE IF EXISTS `medical_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_record` (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '门诊病历，已剔除check',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `wid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '门诊医师',
  `dno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `hospital` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT '初诊/复诊/急诊',
  `companion` varchar(255) DEFAULT NULL COMMENT '是否有陪护',
  `chief_complaint` varchar(255) DEFAULT NULL COMMENT '主诉',
  `present_illness` varchar(255) DEFAULT NULL COMMENT '现病史',
  `timestamp` datetime DEFAULT NULL,
  `temperature` varchar(255) DEFAULT NULL COMMENT '体温 ℃',
  `pulse` varchar(255) DEFAULT NULL COMMENT '脉搏 （次/分）',
  `sbp` varchar(255) DEFAULT NULL COMMENT '收缩压 mmHg',
  `dbp` varchar(255) DEFAULT NULL COMMENT '舒张压 mmHg',
  `pulmonary` varchar(255) DEFAULT NULL COMMENT '呼吸 （次/分）',
  `consciousness` varchar(255) DEFAULT NULL COMMENT '意识状态',
  `measures` varchar(255) DEFAULT NULL COMMENT '处理措施',
  `observation` varchar(255) DEFAULT NULL COMMENT '是否留观',
  `assessment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '初步评估结果/诊断',
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`record_id`) USING BTREE,
  KEY `from_patientid` (`patient_id`) USING BTREE,
  KEY `from_wid` (`wid`) USING BTREE,
  KEY `med_department` (`dno`),
  CONSTRAINT `med_department` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `med_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `med_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_record`
--

LOCK TABLES `medical_record` WRITE;
/*!40000 ALTER TABLE `medical_record` DISABLE KEYS */;
INSERT INTO `medical_record` VALUES (10010,'123123123412341234',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'零号病历');
/*!40000 ALTER TABLE `medical_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine`
--

DROP TABLE IF EXISTS `medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine` (
  `mid` varchar(255) NOT NULL,
  `mname` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `factory` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `store` varchar(255) DEFAULT NULL,
  `specs` varchar(255) DEFAULT NULL,
  `sell` int unsigned DEFAULT '0',
  PRIMARY KEY (`mid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine`
--

LOCK TABLES `medicine` WRITE;
/*!40000 ALTER TABLE `medicine` DISABLE KEYS */;
INSERT INTO `medicine` VALUES ('m13802','阿奇霉素片','薄膜衣片','汕头金石制药总厂有限公司',18.10,'盒','100','0.5g*6片',10),('m13803','氨麻美敏片(Ⅱ)','薄膜衣片','中美天津史克制药有限公司',18.80,'盒','100','20片',11),('m13804','比卡鲁胺片','薄膜衣片','浙江海正药业股份有限公司',750.00,'盒','97','50mg*20片',16),('m13805','吡格列酮片','薄膜衣片','江苏德源药业股份有限公司',57.00,'盒','100','30mg*14s',12),('m13806','雌二醇片/雌二醇地屈孕酮片复合包装','薄膜衣片','Abbott Biologicals B.V.',115.00,'盒','81','28片',33),('m13807','雌二醇屈螺酮片','薄膜衣片','德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)',268.00,'盒','100','28片',3),('m13808','茜芷片','薄膜衣片','甘肃兰药药业有限公司',81.70,'盒','100','0.4g*45片',4),('m13809','童康片','薄膜衣片','广州康和药业有限公司',37.80,'盒','100','0.2g*60片',5),('m13810','血府逐瘀片','薄膜衣片','陕西海天制药有限公司',38.50,'盒','100','0.42g*48片',2),('m13811','缩宫素鼻喷雾剂','鼻喷雾剂','四川美科制药有限公司',52.20,'瓶','100','200U:5ml',22),('m13812','枯草杆菌二联活菌肠溶胶囊','肠溶胶囊','北京韩美药品有限公司',26.80,'盒','100','0.25g*20粒 ',5),('m13813','雷贝拉唑钠肠溶胶囊(大)','肠溶胶囊','济川药业集团有限公司',62.10,'盒','100','20mg*7粒',2),('m13814','雷贝拉唑钠肠溶胶囊(小)','肠溶胶囊','珠海润都制药股份有限公司',37.20,'盒','100','10mg*7粒',3),('m13815','脉血康胶囊','肠溶胶囊','贵州信邦制药股份有限公司',39.90,'盒','100','0.25g*36粒',12),('m13816','阿司匹林肠溶片(J)','肠溶片','意大利 Bayer HealthCare Manufacturing S.r.l.(拜耳医药保健有限公司分装)',16.10,'盒','100','0.1g*30片',4),('m13817','地红霉素肠溶片','肠溶片','浙江金华康恩贝生物制药有限公司',31.20,'盒','100','0.125g*8片',2),('m13818','二甲双胍肠溶片（国）','肠溶片','贵州圣济堂制药有限公司',13.80,'盒','100','0.5g*60片',4),('m13819','复方阿嗪米特肠溶片','肠溶片','扬州一洋制药有限公司',36.10,'盒','100','75mg*20片',12),('m13820','兰索拉唑肠溶片','肠溶片','扬子江药业集团四川海蓉药业有限公司',28.20,'盒','100','15mg*14片',42),('m13821','消栓肠溶胶囊','肠溶微丸胶囊','三门峡赛诺维制药有限公司',50.70,'盒','100','0.2g*24粒',12),('m13822','安脑丸','大蜜丸','哈尔滨蒲公英药业有限公司',62.00,'盒','100','3g*6丸',1),('m13823','前列舒丸','大蜜丸','威海人生药业集团股份有限公司',37.00,'盒','100','9g*10丸',12),('m13824','左氧氟沙星滴耳液','滴耳剂','深圳万和制药有限公司',26.10,'盒','100','25mg:5ml',23),('m13825','复方丹参滴丸','滴丸','天士力制药集团股份有限公司',28.80,'盒','100','27mg*180粒',12),('m13826','宫炎平滴丸','滴丸','广东罗浮山国药股份有限公司',48.30,'盒','100','50mg*240粒',1),('m13827','0.1%氟米龙滴眼剂','滴眼剂','Allergan Pharmaceuticals Ireland',21.90,'支','100','5mg:5ml',2),('m13828','0.5%羧甲基纤维素钠滴眼剂','滴眼剂','Allergan Pharmaceuticals Ireland',58.60,'盒','100','0.4ml*30支',3),('m13829','奥洛他定滴眼剂','滴眼剂','Alcon laboratories (UK) Ltd',112.00,'支','100','5ml',12),('m13830','贝美前列素滴眼剂','滴眼剂','Allergan Sales LLC',173.00,'支','100','0.9mg:3ml',1),('m13831','倍他洛尔滴眼剂','滴眼剂','s.a.ALCON-COUVREUR n.v.',48.30,'支','100','12.5mg:5ml',23),('m13832','吡诺克辛滴眼剂','滴眼剂','参天制药株式会社能登工厂',14.40,'支','100','0.25mg:5ml',12),('m13833','冰珍清目滴眼剂','滴眼剂','湖北远大天天明制药有限公司',22.50,'盒','97','5ml*2支',4),('m13834','冰珍去翳滴眼剂','滴眼剂','湖北远大天天明制药有限公司',16.30,'支','100','10ml',2),('m13835','丙美卡因滴眼剂','滴眼剂','s.a.ALCON-COUVREUR n.v.',40.30,'支','100','75mg:15ml',3),('m13836','玻璃酸钠滴眼剂(J)','滴眼剂','参天制药株式会社能登工厂',30.00,'支','100','5mg:5ml',1),('m13837','玻璃酸钠滴眼剂(国)','滴眼剂','珠海联邦制药股份有限公司',25.80,'支','100','5mg:5ml',2),('m13838','布林佐胺滴眼剂','滴眼剂','Alcon Laboratories(UK) Ltd.',82.80,'支','100','50mg:5ml',3),('m13839','非尼拉敏萘甲唑啉滴眼剂','滴眼剂','s.a.ALCON-COUVREUR n.v.',20.70,'支','100','15ml',2),('m13840','复方右旋糖酐70滴眼液','滴眼剂','江西禾氏美康药业有限公司',29.50,'支','100','15mg:15ml',3),('m13841','复方右旋糖酐70滴眼液','滴眼剂','安徽省双科药业有限公司',29.70,'支','100','15mg:15ml',2),('m13842','更昔洛韦滴眼剂','滴眼剂','湖北远大天天明制药有限公司',20.90,'支','100','8mg:8ml',3),('m13843','加替沙星滴眼剂','滴眼剂','安徽省双科药业有限公司',20.60,'支','99','15mg:5ml',3),('m13844','加替沙星滴眼剂（大）','滴眼剂','楚雄老拨云堂药业有限公司',30.50,'支','100','24mg:8ml',3),('m13845','聚乙二醇滴眼液','滴眼剂','Alcon Laboratories,Inc',40.50,'支','100','5ml',1),('m13846','聚乙烯醇滴眼剂(J)','滴眼剂','Taiwan Biotech Co.Ltd',38.70,'盒','100','0.5ml*10支',2),('m13847','聚乙烯醇滴眼液(国)','滴眼剂','湖北远大天天明制药有限公司',28.40,'盒','100','0.8ml*15支',2),('m13848','卡波姆滴眼剂','滴眼剂','Dr.Gerhard Mann. Chem.-Pharm. Fabrik Gmbh',29.70,'支','100','20mg:10g',3),('m13849','卡替洛尔滴眼剂','滴眼剂','中国大冢制药有限公司',25.80,'支','100','5ml',2),('m13850','拉坦前列素滴眼剂','滴眼剂','PFIZER SA',218.00,'支','100','125ug：2.5ml',1),('m13851','拉坦前列素滴眼液','滴眼剂','华润紫竹药业有限公司',158.00,'支','100','125ug：2.5ml',1),('m13852','氯替泼诺滴眼剂','滴眼剂','Bausch&Lomb Incorporated',86.00,'支','100','25mg：5ml',1),('m13853','泼尼松龙滴眼剂','滴眼剂','Allergan Pharmaceuticals Ireland',35.20,'支','100','50mg:5ml',1),('m13854','普拉洛芬滴眼剂（J）','滴眼剂','千寿制药株式会社',44.30,'支','100','5mg:5ml',1),('m13855','普拉洛芬滴眼液（国）','滴眼剂','山东海山药业有限公司',41.30,'支','98','5mg:5ml',3),('m13856','七叶洋地黄双苷滴眼剂','滴眼剂','Pharma Stulln GmbH 德国视都灵药品有限责任公司',41.00,'盒','100','0.4ml*10支',0),('m13857','曲伏前列素滴眼剂','滴眼剂','ALCON Cusi, S.A.',225.00,'支','100','0.1mg:2.5ml',1),('m13858','双氯芬酸钠滴眼剂','滴眼剂','沈阳兴齐眼药股份有限公司',14.30,'支','100','5mg:5ml',1),('m13859','双氯芬酸钠滴眼剂','滴眼剂','沈阳兴齐眼药股份有限公司',21.00,'盒','100','1mg:1ml*5支',0),('m13860','妥布霉素滴眼剂','滴眼剂','s.a.ALCON-COUVREUR n.v.',18.60,'支','100','15mg:5ml',0),('m13861','妥布霉素地塞米松滴眼剂(J)','滴眼剂','s.a.ALCON-COUVREUR n.v.',37.00,'支','100','20mg:5ml',0),('m13862','溴莫尼定滴眼剂','滴眼剂','Allergan Pharmaceuticals Ireland',81.10,'支','100','10mg:5ml',0),('m13863','眼氨肽滴眼剂','滴眼剂','陕西博森生物制药股份集团有限公司',21.30,'支','100','25g:10ml',0),('m13864','氧氟沙星滴眼剂(J)','滴眼剂','参天制药株式会社能登工厂',22.00,'支','100','15mg:5ml',0),('m13865','依美斯汀滴眼剂','滴眼剂','Alcon laboratories (UK) Ltd',38.50,'支','100','2.5mg:5ml',0),('m13866','重组牛碱性成纤维细胞生长因子滴眼剂','滴眼剂','珠海亿胜生物制药有限公司',27.60,'支','100','21000IU:5ml',0),('m13867','重组人表皮生长因子衍生物滴眼剂','滴眼剂','深圳市华生元基因工程发展有限公司',31.50,'支','100','15000u:3ml',0),('m13868','重组人干扰素a2b滴眼液','滴眼剂','安徽安科生物工程(集团)股份有限公司',24.10,'支','100','100万IU:5ml',0),('m13869','左氧氟沙星滴眼剂(J)','滴眼剂','参天制药株式会社能登工厂',35.60,'支','100','5ml',0),('m13870','左氧氟沙星滴眼剂(国)','滴眼剂','山东博士伦福瑞达制药有限公司',12.10,'支','100','15mg:5ml',0),('m13871','复方熊胆滴眼液','滴眼液','长春普华制药股份有限公司',29.70,'支','100','12ml',0),('m13872','金珍滴眼液','滴眼液','安徽省双科药业有限公司',36.20,'支','100','8ml',0),('m13873','近视乐滴眼液','滴眼液','长春普华制药股份有限公司',47.50,'支','100','8ml',0),('m13874','麝珠明目滴眼液','滴眼液','福建麝珠明眼药股份有限公司',36.70,'支','100','300mg:5ml',0),('m13875','镇痛活络酊','酊剂','上海景峰制药有限公司',44.90,'瓶','100','50ml',0),('m13876','外用重组人碱性成纤维细胞生长因子','冻干粉剂','南海朗肽制药有限公司',68.70,'支','100','20000IU',0),('m13877','阿莫西林克拉维酸钾分散片','分散片','南京臣功制药股份有限公司',23.60,'盒','100','0.457g*8片',0),('m13878','氯雷他定分散片','分散片','北京双鹭药业股份有限公司',25.50,'盒','100','10mg*10片',0),('m13879','阿莫西林克拉维酸钾干混悬剂','干混悬剂','上海海虹实业（集团）巢湖今辰药业有限公司',27.40,'盒','100','0.643g*6袋',0),('m13880','阿奇霉素干混悬剂','干混悬剂','辉瑞制药有限公司',43.60,'盒','100','0.1g*6袋',0),('m13881','丹莪妇康煎膏','膏剂','滇虹药业集团股份有限公司',56.30,'瓶','100','150g',0),('m13882','多磺酸粘多糖软膏','膏剂','obilat Produktions GmbH',31.50,'支','100','14g',20),('m13883','肤舒止痒膏','膏剂','贵州科福丽康制药有限公司',27.60,'支','100','100g',12),('m13884','复方角菜酸酯乳膏','膏剂','西安杨森制药有限公司',33.60,'支','100','20g',2),('m13885','精制狗皮膏','膏剂','黄石卫生材料药业有限公司',15.90,'盒','100','7cm×10cm*6贴',13),('m13886','膦甲酸钠乳膏','膏剂','上海现代制药股份有限公司',16.70,'支','100','5g:0.15g',1),('m13887','玫芦消痤膏','膏剂','佳程药业（贵州）有限责任公司',23.50,'支','100','30g',1),('m13888','咪康唑乳膏','膏剂','西安杨森制药有限公司',14.50,'支','100','20g',2),('m13889','莫米松乳膏','膏剂','上海通用药业股份有限公司',12.30,'支','100','5mg',0),('m13890','莫匹罗星乳膏','膏剂','中美天津史克制药有限公司',14.00,'支','100','5g',12),('m13891','曲安奈德益康唑乳膏','膏剂','西安杨森制药有限公司',18.90,'支','100','15g',2),('m13892','润肌皮肤膏','膏剂','广西金海堂药业有限责任公司',54.80,'盒','100','10g',0),('m13893','湿润烧伤膏','膏剂','汕头市美宝制药有限公司',25.00,'支','100','40g',0),('m13894','双氯芬酸钠二乙胺乳膏','膏剂','北京诺华制药有限公司',22.90,'支','100','20g:0.2g',0),('m13895','复方阿胶浆','合计','山东东阿阿胶股份有限公司',38.40,'盒','100','20ml*12支',0),('m13896','长春胺缓释胶囊','缓释胶囊','烟台鲁银药业有限公司',63.60,'盒','100','30mg*12粒',0),('m13897','单硝酸异山梨酯缓释胶囊','缓释胶囊','珠海许瓦兹制药有限公司',39.10,'盒','100','50mg*10粒',0),('m13898','坦洛新缓释胶囊','缓释胶囊','浙江海力生制药有限公司',77.00,'盒','100','0.2mg*10粒',0),('m13899','坦索罗辛缓释胶囊','缓释胶囊','安斯泰来制药(中国)有限公司',67.90,'盒','100','0.2mg*10粒',0),('m13900','头孢克洛缓释胶囊','缓释胶囊','扬子江药业集团有限公司',25.50,'盒','100','125mg*12粒',22),('m13901','非洛地平缓释片','缓释片','阿斯利康制药有限公司',38.00,'盒','99','5mg*10片',3),('m13902','格列齐特缓释片','缓释片','施维雅(天津)制药有限公司',56.60,'盒','100','30mg*30片',1),('m13903','克拉霉素缓释片','缓释片','江苏恒瑞医药股份有限公司',21.40,'盒','100','0.5g*3片',12),('m13904','乌拉地尔缓释片','缓释片','西安利君制药有限责任公司',22.90,'盒','100','30mg*20片',0),('m13905','硝苯地平缓释片','缓释片','浙江昂利康制药有限公司',11.10,'盒','100','10mg*48片',12),('m13906','多潘立酮混悬液','混悬剂','JK西安杨森制药有限公司',14.50,'瓶','100','100ml',0),('m13907','铝镁加混悬液','混悬剂','扬州一洋制药有限公司',30.90,'盒','100','1.5g:15ml*12袋',0),('m13908','阿法骨化醇软胶囊(J）','胶囊','Tev Pharmaceutical Industries Ltd.',78.20,'盒','100','1ug*10粒',0),('m13909','阿法骨化醇软胶囊（国）','胶囊','南通华山药业有限公司',34.50,'盒','100','0.25ug*30粒',12),('m13910','阿莫西林胶囊','胶囊','昆明贝克诺顿制药有限公司',11.00,'盒','100','250mg*20粒',12),('m13911','百乐眠胶囊','胶囊','扬子江药业集团有限公司',37.90,'盒','100','270mg*24粒',1),('m13912','百令胶囊','胶囊','杭州中美华东制药有限公司',74.90,'盒','100','0.5g*42s',0),('m13913','胞磷胆碱钠胶囊','胶囊','齐鲁制药有限公司',45.70,'盒','100','0.1g*24粒',2),('m13914','标准桃金娘油肠溶胶囊','胶囊','德国保时佳大药厂',24.40,'盒','100','300mg*10粒',0),('m13915','布洛芬缓释胶囊','胶囊','中美天津史克制药有限公司',14.80,'盒','94','0.3g*20粒',6),('m13916','参松养心胶囊','胶囊','北京以岭药业有限公司',29.90,'盒','100','400mg*36粒',12),('m13917','地尔硫卓缓释胶囊','胶囊','天津田边制药有限公司',20.90,'盒','100','90mg*10粒',0),('m13918','多烯磷脂酰胆碱胶囊','胶囊','赛诺菲（北京）制药有限公司',49.10,'盒','100','228mg*24粒',0),('m13919','氟桂利嗪胶囊','胶囊','JK西安杨森制药有限公司',27.20,'盒','100','5mg*20粒',0),('m13920','妇科千金胶囊','胶囊','株洲千金药业股份有限公司',26.70,'盒','100','0.4g*24粒',0),('m13921','妇科养荣胶囊','胶囊','西安阿房宫药业股份有限公司',34.50,'盒','100','0.35g*36粒',0),('m13922','妇炎舒胶囊','胶囊','陕西东科制药有限责任公司',27.50,'盒','100','0.4g*48粒',0),('m13923','妇月康胶囊','胶囊','陕西东泰制药有限公司',30.90,'盒','100','600mg*48粒',0),('m13924','复方乌鸡胶囊','胶囊','江西天施康中药股份有限公司',21.40,'盒','100','0.25g*20粒',0),('m13925','复方血栓通胶囊','胶囊','广东众生药业股份有限公司',26.00,'盒','100','0.5g*30粒',0),('m13926','复方益母胶囊','胶囊','翔宇药业股份有限公司',33.10,'盒','100','0.42g*45粒',0),('m13927','复方珍珠暗疮胶囊','胶囊','清华德人西安幸福制药有限公司',45.30,'盒','100','0.3g*72粒 ',0),('m13928','宫瘤宁胶囊','胶囊','康县独一味生物制药有限公司',46.60,'盒','100','0.3g*54粒',0),('m13929','宫炎平胶囊','胶囊','江西民济药业有限公司',27.40,'盒','100','0.25g*48粒',0),('m13930','骨愈灵胶囊','胶囊','陕西威信制药有限公司',62.80,'盒','100','400mg*60粒',0),('m13931','红花逍遥胶囊','胶囊','云南楚雄天利药业有限公司',37.40,'盒','100','0.4g*24粒',0),('m13932','黄葵胶囊','胶囊','江苏苏中药业集团股份有限公司',34.50,'盒','100','0.5g*30粒',0),('m13933','黄体酮胶囊','胶囊','浙江仙琚制药股份有限公司',35.70,'盒','100','50mg*20粒',0),('m13934','活血止痛胶囊','胶囊','江西百神昌诺药业有限公司',43.40,'盒','100','0.5g*48粒',0),('m13935','甲钴铵胶囊','胶囊','扬子江药业集团南京海陵药业有限公司',52.60,'盒','100','0.5mg*50粒',0),('m13936','金嗓利咽胶囊','胶囊','西安碑林药业股份有限公司',29.50,'盒','100','0.4g*12粒',0),('m13937','金水宝胶囊','胶囊','江西济民可信金水宝制药有限公司',43.20,'盒','100','330mg*63粒',0),('m13938','抗妇炎胶囊','胶囊','贵州远程制药有限责任公司',28.70,'盒','100','0.35g*36粒',0),('m13939','六锐胶囊','胶囊','西安大唐制药集团有限公司',61.50,'盒','100','0.25g*12粒',0),('m13940','六味安消胶囊','胶囊','贵州信邦制药股份有限公司',23.30,'盒','100','500mg*36粒',0),('m13941','六味香连胶囊','胶囊','江西德瑞制药有限公司',35.30,'盒','100','0.34g*12粒',0),('m13942','龙心素胶囊','胶囊','云南永安制药有限公司',29.70,'盒','100','0.15g*12粒',0),('m13943','卵磷脂络合碘胶囊','胶囊','西安力邦制药有限公司',77.40,'盒','100','0.1mg*30粒',0),('m13944','罗红霉素胶囊','胶囊','扬子江药业集团有限公司',23.50,'盒','100','150mg*12粒',0),('m13945','脉络通胶囊','胶囊','扬子江药业集团南京海陵药业有限公司',34.50,'盒','100','0.42g*12粒',0),('m13946','脑心通胶囊','胶囊','陕西步长制药有限公司',29.80,'盒','100','400mg*36粒',1),('m13947','宁泌泰胶囊','胶囊','贵阳新天药业股份有限公司',35.70,'盒','100','380mg*36粒',1),('m13948','泮托拉唑钠肠溶胶囊','胶囊','杭州中美华东制药有限公司',49.50,'盒','100','40mg*7片',1),('m13949','平消胶囊','胶囊','西安正大制药有限公司',70.20,'盒','100','230mg*100粒',1),('m13950','芪苈强心胶囊','胶囊','石家庄以岭药业股份有限公司',38.60,'盒','100','0.3g*36粒',1),('m13951','强筋健骨胶囊','胶囊','西安阿房宫药业股份有限公司',35.10,'盒','100','0.3g*36粒',1),('m13952','乳酸菌阴道胶囊','胶囊','西安正浩生物制药有限公司',32.80,'盒','100','250ug*10枚',0),('m13953','苏黄止咳胶囊','胶囊','扬子江药业集团北京海燕药业有限公司',91.50,'盒','100','0.45g*24粒',0),('m13954','替普瑞酮胶囊','胶囊','卫材(中国)药业有限公司',29.60,'盒','100','50mg*20粒',0),('m13955','天丹通络胶囊','胶囊','山东凤凰制药股份有限公司',39.90,'盒','100','400mg*60s',1),('m13956','天麻素胶囊','胶囊','昆明制药集团股份有限公司',24.90,'盒','100','50mg*24粒',1),('m13957','通心络胶囊','胶囊','石家庄以岭药业股份有限公司',31.60,'盒','100','260mg*30粒',1),('m13958','翁沥通胶囊','胶囊','华北制药股份有限公司',23.60,'盒','100','400mg*24粒',1),('m13959','乌灵胶囊','胶囊','浙江佐力药业股份有限公司',46.10,'盒','100','0.33g*36粒',1),('m13960','小建中胶囊','胶囊','贵州太和制药有限公司',35.70,'盒','100','0.4g*24粒',0),('m13961','协日嘎四味汤胶囊','胶囊','湖南九典制药有限公司',38.00,'盒','100','0.35g*24粒',0),('m13962','缬沙坦胶囊','胶囊','北京诺华制药有限公司',45.70,'盒','100','80mg*7粒',0),('m13963','心速宁胶囊','胶囊','陕西摩美得制药有限公司',37.60,'盒','100','0.48g*36粒',0),('m13964','血塞通胶囊','胶囊','云南维和药业股份有限公司',29.40,'盒','100','0.1g*20粒',12),('m13965','血脂康胶囊','胶囊','北京北大维信生物科技有限公司',14.40,'盒','100','0.3g*12s',0),('m13966','益母草胶囊','胶囊','沈阳永大制药有限公司',23.30,'盒','100','0.35g*36粒',0),('m13967','益诺胶囊','胶囊','广州康和药业有限公司',72.50,'盒','100','0.32g*8粒',11),('m13968','益心舒胶囊','胶囊','贵州信邦制药股份有限公司',37.90,'盒','100','0.4g*36粒',12),('m13969','益血生胶囊','胶囊','吉林金复康药业有限公司',30.70,'盒','100','250mg*36粒',0),('m13970','致康胶囊','胶囊','西安千禾药业有限责任公司',49.10,'盒','100','0.3g*36粒',0),('m13971','胶体酒石酸铋胶囊','胶囊 ','山西星火维敏制药有限公司',35.70,'盒','100','55mg*24粒',10),('m13972','芪胶升白胶囊','胶囊 ','贵州汉方药业有限公司',67.90,'盒','100','0.5g*36粒',0),('m13973','障眼明胶囊','胶囊 ','湖南天济草堂制药有限公司',31.60,'盒','100','0.25g*36粒',0),('m13974','骨化三醇胶丸(J)','胶丸','R.P.Scherer GmbH & Co. KG',62.00,'盒','100','0.25ug*10粒',0),('m13975','荆花胃康胶丸','胶丸','天士力制药集团股份有限公司',55.90,'盒','100','80mg*30s',0),('m13976','铝镁二甲硅油咀嚼片','咀嚼片','永信药品工业(昆山)有限公司',47.30,'盒','100','0.3719g*30片',0),('m13977','孟鲁司特钠咀嚼片','咀嚼片','四川大冢制药有限公司',33.40,'盒','100','5mg*5片',0),('m13978','维D钙咀嚼片','咀嚼片','美国安士制药有限公司生产/安士制药(中山)有限公司分包装',49.00,'瓶','100','300mg*60片',0),('m13979','连花清瘟颗粒','颗粒','北京以岭药业有限公司',27.40,'盒','100','0.6g*10袋',0),('m13980','益视颗粒','颗粒 ','山西仁源堂药业有限公司',35.60,'盒','100','15g*9袋',1),('m13981','阿莫西林颗粒','颗粒剂','珠海联邦制药股份有限公司',16.40,'盒','100','0.125g*24袋',1),('m13982','葆宫止血颗粒','颗粒剂','天津中盛海天制药有限公司',36.80,'盒','100','15g*6袋',1),('m13983','产复康颗粒','颗粒剂','深圳三顺制药有限公司',40.50,'盒','100','5g*15袋',1),('m13984','产复欣颗粒','颗粒剂','吉林省辉南辉发制药股份有限公司',36.00,'盒','100','10g*6袋',1),('m13985','复方碳酸钙泡腾颗粒','颗粒剂','山东达因海洋生物制药股份有限公司',26.60,'盒','100','1.5g*20袋',0),('m13986','甘草锌颗粒','颗粒剂','山东达因海洋生物制药股份有限公司',12.70,'盒','100','1.5g*10袋',1),('m13987','宫炎康颗粒','颗粒剂','陕西白鹿制药股份有限公司',39.10,'盒','100','9g*6袋',0),('m13988','红花逍遥颗粒','颗粒剂','江西桔王药业有限公司',44.30,'盒','100','3g*12袋',1),('m13989','加味生化颗粒','颗粒剂','武汉中联集团四药药业有限公司',25.90,'盒','100','15g*10袋',1),('m13990','抗感颗粒','颗粒剂','四川好医生攀西药业有限责任公司',19.30,'盒','100','5g*12袋',1),('m13991','赖氨葡锌颗粒','颗粒剂','长沙东风药业有限公司',34.70,'盒','100','5g*20包',1),('m13992','赖氨酸维B12颗粒','颗粒剂','湖南方盛制药股份有限公司',24.40,'盒','100','10g*10袋',2),('m13993','乐孕宁颗粒','颗粒剂','江西杏林白马药业有限公司',37.60,'盒','100','5g*12袋',3),('m13994','鹿胎颗粒','颗粒剂','吉林敖东延边药业股份有限公司',33.80,'盒','100','10g*10袋',4),('m13995','母乳多颗粒','颗粒剂','陕西康惠制药股份有限公司',35.40,'盒','100','18g*6袋',5),('m13996','木丹颗粒','颗粒剂','辽宁奥达制药有限公司',140.00,'盒','100','7g*12袋',2),('m13997','尿毒清颗粒','颗粒剂','康臣药业（内蒙古）有限责任公司',76.60,'盒','100','5g*18袋',12),('m13998','匹多莫德颗粒剂','颗粒剂','浙江仙琚制药股份有限公司',47.70,'盒','100','0.4g:2g*6袋',23),('m13999','热淋清颗粒','颗粒剂','贵州威门药业股份有限公司',36.00,'盒','100','4g*8袋',4),('m14000','双橘颗粒','颗粒剂','江西南昌济生制药厂',53.10,'盒','100','10g*6袋',1),('m14001','碳酸钙D3颗粒','颗粒剂','北京康远制药有限公司',31.30,'盒','100','0.5g/5ug*6袋',2),('m14002','胃苏颗粒','颗粒剂','扬子江药业集团江苏制药股份有限公司',26.60,'盒','100','5g*9袋',12),('m14003','稳心颗粒','颗粒剂','山东步长制药股份有限公司',28.60,'盒','100','9g*9袋',0),('m14004','消银颗粒','颗粒剂','陕西康惠制药股份有限公司',28.30,'盒','100','3.5g*12袋',0),('m14005','小麦纤维素颗粒','颗粒剂','瑞典Recip AB',74.80,'盒','100','3.5g*10袋',1),('m14006','醒脾养儿颗粒','颗粒剂','贵州健兴药业有限公司',20.70,'盒','100','2g*12袋',1),('m14007','养血清脑颗粒','颗粒剂','天士力制药集团股份有限公司',36.70,'盒','100','4g*15袋',1),('m14008','贞芪扶正颗粒','颗粒剂','甘肃扶正药业科技股份有限公司',49.70,'盒','100','5g*12袋',1),('m14009','珠珀猴枣散','颗粒剂','香港保和堂制药有限公司',59.80,'盒','100','0.3g*10袋',0),('m14010','硝苯地平控释片','控释片','德国 Bayer Schering Pharma AG(拜耳医药保健有限公司分装',35.80,'盒','100','30mg*7片',1),('m14011','氨溴特罗口服溶液剂','口服溶液剂','北京韩美药品有限公司',27.60,'瓶','100','100ml',1),('m14012','鼻窦炎口服液','口服溶液剂','太极集团重庆桐君阁药厂有限公司',14.70,'盒','100','10ml*6支',0),('m14013','产妇安合剂','口服溶液剂','新乡佐今明制药股份有限公司',33.40,'盒','100','25ml*6支',1),('m14014','蛋白琥珀酸铁口服溶液','口服溶液剂','ITALFARMACO S.A',138.00,'盒','100','15ml*10支',0),('m14015','对乙酰氨基酚混悬液','口服溶液剂','上海强生制药有限公司',15.30,'瓶','100','3.2g:100ml',0),('m14016','多维铁口服溶液剂','口服溶液剂','湖南康寿制药有限公司',34.20,'瓶','100','150ml',0),('m14017','复方氨酚甲麻口服溶液剂','口服溶液剂','北京韩美药品有限公司',19.30,'瓶','100','100ml',0),('m14018','复方福尔可定口服溶液剂','口服溶液剂','澳美制药厂',25.40,'瓶','100','150ml',0),('m14019','复方红衣补血口服液','口服溶液剂','翔宇药业股份有限公司',20.90,'盒','100','10ml*10支',0),('m14020','健胃消食口服液','口服溶液剂','济川药业集团有限公司',55.20,'盒','100','10ml*12瓶',10),('m14021','蓝芩口服液','口服溶液剂','扬子江药业集团有限公司',46.00,'盒','100','10ml*12支',20),('m14022','葡萄糖酸钙锌口服溶液剂','口服溶液剂','澳诺(中国)制药有限公司',34.00,'盒','100','10ml*18支',12),('m14023','蒲地蓝口服液','口服溶液剂','济川药业集团有限公司',28.50,'盒','100','10ml*6支',32),('m14024','芩翘口服液','口服溶液剂','沈阳飞龙药业有限公司',33.90,'盒','100','10ml*6支',0),('m14025','乳果糖口服溶液剂','口服溶液剂','北京韩美药品有限公司',40.30,'瓶','100','66.7g:100ml',0),('m14026','双黄连口服液','口服溶液剂','河南太龙药业股份有限公司',20.40,'盒','100','10ml*12支',1),('m14027','四磨汤口服液','口服溶液剂','湖南汉森制药股份有限公司',24.40,'盒','100','10ml*10支',0),('m14028','通天口服液','口服溶液剂','太极集团重庆涪陵制药厂有限公司',19.70,'盒','100','10ml*6支',0),('m14029','茵栀黄口服液','口服溶液剂','北京华润高科天然药物有限公司',21.70,'盒','100','10ml*6支',0),('m14030','右旋糖酐铁口服溶液剂','口服溶液剂','内蒙古康源药业有限公司',30.60,'盒','100','25mg:5ml*10支',0),('m14031','孕康口服液','口服溶液剂','江西济民可信药业有限公司',25.90,'盒','100','20ml*5支',0),('m14032','复方维A酸凝胶','凝胶','上海现代制药股份有限公司',27.70,'支','100','10g',0),('m14033','黄体酮阴道缓释凝胶','凝胶剂','Fleet laboratories Limited',1184.00,'盒','100','90mg*15支',0),('m14034','甲硝唑凝胶','凝胶剂','天津市天骄制药有限公司',30.60,'盒','100','37.5mg*7枚',0),('m14035','苦参凝胶','凝胶剂','贵阳新天药业股份有限公司',49.70,'盒','100','5g*4支',0),('m14036','磷酸铝凝胶','凝胶剂','韩国保宁制药株式会社',24.10,'盒','100','20g：11g',0),('m14037','重组人干扰素a-2b凝胶','凝胶剂','兆科药业(合肥)有限公司',46.40,'支','100','5g',0),('m14038','妇得康泡沫剂','泡沫剂','贵州汉方药业有限公司',38.60,'瓶','100','15g',0),('m14039','两性霉素B阴道泡腾片','泡腾片','华北制药股份有限公司',45.50,'盒','100','5mg*12片',0),('m14040','乙酰半胱氨酸泡腾片','泡腾片','浙江金华康恩贝生物制药有限公司',37.00,'盒','100','0.6g*6片',0),('m14041','金喉健喷雾剂','喷雾剂','贵州宏宇药业有限公司',24.50,'盒','100','20ml',0),('m14042','阿卡波糖片(J)','片剂','barer schering pharma AG',74.20,'盒','100','50mg*30片',0),('m14043','阿卡波糖片(国)','片剂','杭州中美华东制药有限公司',51.20,'盒','100','50mg*30片',0),('m14044','阿仑膦酸钠片','片剂','Merck Sharp&Dohme(Italia)SPA',70.80,'盒','100','70mg*1片',12),('m14045','阿托伐他汀钙片(J)','片剂','Pfizer Ireland Pharmaceuticals',72.20,'盒','100','20mg*7片',0),('m14046','阿托伐他汀钙片(国)','片剂','北京嘉林药业股份有限公司',31.10,'盒','100','10mg*7片',0),('m14047','艾地苯醌片','片剂','深圳海王药业有限公司',56.30,'盒','100','30mg*12片',0),('m14048','氨基葡萄糖片','片剂','四川绿叶宝光药业股份有限公司',38.20,'盒','100','0.24g*30片',0),('m14049','氨氯地平片','片剂','辉瑞制药有限公司',38.00,'盒','100','5mg*7片',1),('m14050','昂丹司琼片','片剂','齐鲁制药有限公司',181.00,'盒','100','4mg*12片',0),('m14051','奥美拉唑镁肠溶片','片剂','AstraZeneca.AB',94.30,'盒','100','20mg*7片',1),('m14052','贝尼地平片','片剂','华夏药业集团有限公司',34.50,'盒','100','2mg*24片',1),('m14053','薄芝片','片剂','浙江瑞新药业股份有限公司',48.70,'盒','100','0.16g*60片',1),('m14054','草木犀流浸液片','片剂','生晃荣养药品株式会社Seiko Eiyo Yakuhin Co.，LTD',46.00,'盒','100','25mg*50片',1),('m14055','醋甲唑胺片','片剂','杭州澳医保灵药业有限公司',29.90,'盒','100','25mg*10s',1),('m14056','单硝酸异山梨酯片','片剂','鲁南贝特制药有限公司',47.80,'盒','100','20mg*48片',0),('m14057','地屈孕酮片','片剂','Abbott Biologicals B.V.',131.00,'盒','98','10mg*20片',3),('m14058','递法明片','片剂','法国乐康美的澜制药厂',75.80,'盒','100','0.4g*20片',0),('m14059','多潘立酮片','片剂','西安杨森制药有限公司',22.40,'盒','100','10mg*42片',1),('m14060','厄贝沙坦片','片剂','Sanofi Winthrop Industrie',36.90,'盒','100','150mg*7片',1),('m14061','厄贝沙坦氢氯噻嗪片','片剂','Sanofi Winthrop Industrie',37.10,'盒','100','150mg*7片',1),('m14062','二甲双胍片(J）','片剂','中美上海施贵宝制药有限公司',28.90,'盒','100','0.5g*20片',0),('m14063','非索非那定片','片剂','浙江万晟药业有限公司',24.50,'盒','100','30mg*28片',1),('m14064','氟哌噻吨美利曲辛片','片剂','H.Lundbeck A/S 丹麦灵北制药有限公司',66.70,'盒','100','10.5mg*20片',1),('m14065','妇乐片','片剂','陕西东泰制药有限公司',39.30,'盒','100','0.5g*30片',0),('m14066','复方醋酸棉酚片','片剂','西安北方药业有限公司',64.40,'盒','100','20mg*5片',1),('m14067','复方硫酸亚铁叶酸片','片剂','吉林省西点药业科技发展股份有限公司',34.90,'盒','100','50mg*36粒',11),('m14068','复方米非司酮片','片剂','湖北葛店人福药业有限责任公司',67.90,'盒','100','35mg*2片',12),('m14069','复方嗜酸乳杆菌片','片剂','通化金马药业集团股份有限公司',37.70,'盒','100','0.5g*18片',1),('m14070','复方夏天无片','片剂','江西天施康中药股份有限公司',27.10,'盒','100','0.32g*42s',1),('m14071','复方血栓通片','片剂','扬州中惠制药有限公司',32.20,'盒','100','0.4g*36片',1),('m14072','复明片','片剂','西安碑林药业股份有限公司',30.90,'盒','100','310mg*90s',0),('m14073','格列美脲片(J)','片剂','赛诺菲（北京）制药有限公司',77.90,'盒','100','2mg*15片',1),('m14074','格列美脲片(国)','片剂','山东达因海洋生物制药股份有限公司',29.30,'盒','100','2mg*24片',1),('m14075','和血明目片','片剂','西安碑林药业股份有限公司',44.20,'盒','100','300mg*60片',11),('m14076','琥珀酸亚铁片','片剂','金陵药业股份有限公司南京金陵制药厂',29.90,'盒','100','0.1g*24片',1),('m14077','琥乙红霉素片','片剂','西安利君制药有限责任公司',11.70,'盒','100','0.125g*24片',1),('m14078','甲钴胺片','片剂','江苏德源药业股份有限公司',19.70,'盒','100','0.5mg*24片',12),('m14079','甲巯咪唑片（J）','片剂','Merck KGaA',33.00,'盒','100','10mg*50片',0),('m14080','卡维地洛片','片剂','JK齐鲁制药有限公司',16.20,'盒','100','12.5mg*14片',0),('m14081','坎地沙坦酯片','片剂','重庆圣华曦药业股份有限公司',22.70,'盒','100','4mg*14片',0),('m14082','克霉唑阴道片(J)','片剂','Bayer Pharma AG',47.20,'盒','100','0.5g*1片',0),('m14083','克霉唑阴道片(国)','片剂','湖南华纳大药厂有限公司',29.70,'盒','100','0.5g*3片',0),('m14084','坤复康片','片剂','广东在田药业有限公司',49.30,'盒','100','0.45g*48片',0),('m14085','来曲唑片','片剂','江苏恒瑞医药股份有限公司',149.00,'盒','100','2.5mg*10片',10),('m14086','利托君片','片剂','广东先强药业股份有限公司',50.00,'盒','100','10mg*10片',1),('m14087','铝碳酸镁片','片剂','K拜耳医药保健有限公司',23.90,'盒','100','0.5g*20片',1),('m14088','氯沙坦钾片','片剂','扬子江药业集团四川海蓉药业有限公司',37.30,'盒','100','50mg*7片',1),('m14089','迈之灵片','片剂','德国礼达大药厂',49.90,'盒','100','150mg*20片',0),('m14090','脉君安片','片剂','武汉中联集团四药药业有限公司',22.40,'盒','100','500mg*48片',1),('m14091','米非司酮/米索前列醇片','片剂','华润紫竹药业有限公司',55.50,'盒','100','25mg*6片/0.2g*3片',1),('m14092','米非司酮片','片剂','华润紫竹药业有限公司',24.30,'盒','100','25mg*6片',0),('m14093','莫沙必利片','片剂','江苏豪森药业股份有限公司',21.50,'盒','100','5mg*24片',1),('m14094','莫沙必利片(J)','片剂','住友制药（苏州）有限公司',25.60,'盒','100','5mg*10片',1),('m14095','莫西沙星片','片剂','德国 Bayer Schering Pharma AG(拜耳医药保健有限公司分装)',87.20,'盒','100','400mg*3片',0),('m14096','凝结芽孢杆菌活菌片','片剂','青岛东海药业有限公司',40.40,'盒','100','0.35g*30片',1),('m14097','七叶皂苷钠片','片剂','山东绿叶制药有限公司',50.00,'盒','100','30mg*24片',0),('m14098','曲美他嗪片','片剂','施维雅(天津)制药有限公司',53.60,'盒','100','20mg*30片',1),('m14099','炔雌醇环丙孕酮片','片剂','德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)',59.80,'盒','100','2.035mg*21片',0),('m14100','乳增宁片','片剂','深圳三顺制药有限公司',50.00,'盒','100','0.6g*60s',0),('m14101','瑞格列奈片(J)','片剂','德国Boehringer Ingelheim Pharma GmbH & Co.KG',74.20,'盒','100','1mg*30片',0),('m14102','瑞格列奈片(国)','片剂','江苏豪森药业股份有限公司',21.60,'盒','100','0.5mg*30片 ',0),('m14103','瑞舒伐他汀片','片剂','浙江京新药业股份有限公司',35.20,'盒','100','5mg*12片',20),('m14104','双歧杆菌乳杆菌三联活菌片','片剂','内蒙古双奇药业股份有限公司',36.70,'盒','100','500mg*36片',2),('m14105','司他斯汀片','片剂','回音必集团抚州制药有限公司',41.00,'盒','100','1mg*20片',2),('m14106','替勃龙片','片剂','华润紫竹药业有限公司',36.20,'盒','100','2.5mg*7片',3),('m14107','替勃龙片(J)','片剂','南京欧加农制药有限公司',48.90,'盒','100','2.5mg*7片',3),('m14108','替米沙坦片','片剂','Boehringer Ingelheim International GmbH',43.40,'盒','100','80mg*7片',1),('m14109','胃复春片','片剂','杭州胡庆余堂药业有限公司',20.60,'盒','100','359mg*60片',1),('m14110','戊酸雌二醇/雌二醇环丙孕酮片','片剂','德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)',77.10,'盒','100','2mg*11片/2mg*10片',1),('m14111','戊酸雌二醇片','片剂','德国 Schering GmbH & Co.Produktions KG(拜耳医药保健有限公司广州分公司分装)',32.80,'盒','100','1mg*21片',1),('m14112','西格列汀片','片剂','Merck Sharp & Dohme Italia SPA',63.90,'盒','100','100mg*7片',0),('m14113','香菊片','片剂','陕西白云制药有限公司',36.70,'盒','100','0.32g*72片',0),('m14114','心可舒片','片剂','山东沃华医药科技股份有限公司',24.10,'盒','100','310mg*48片',0),('m14115','心神宁片','片剂','延安常泰药业有限责任公司',39.30,'盒','100','250mg*80片',0),('m14116','辛伐他汀片','片剂','Merck Sharp & Dohme B.V.',24.20,'盒','100','20mg*7片',0),('m14117','辛芩片','片剂','四川志远广和制药有限公司',33.90,'盒','100','0.8g*36s',0),('m14118','杏香兔耳风片','片剂','江西天施康中药股份有限公司',46.90,'盒','100','0.3g*72s',0),('m14119','血塞通片','片剂','云南特安呐制药股份有限公司',37.00,'盒','100','50mg*60片',0),('m14120','血栓心脉宁片','片剂','吉林华康药业股份有限公司',33.60,'盒','100','0.4g*18片',0),('m14121','依那普利片（大）','片剂','扬子江药业集团江苏制药股份有限公司',28.00,'盒','100','10mg*32片',0),('m14122','依帕司他片','片剂','扬子江药业集团南京海陵药业有限公司',43.60,'盒','100','50mg*10片',0),('m14123','益脉康分散片','片剂','云南白药集团大理药业有限责任公司',40.40,'盒','100','0.55g*36s',0),('m14124','益气补血片','片剂','四平市吉特药业有限公司',33.10,'盒','100','60片',0),('m14125','银花泌炎灵片','片剂','吉林华康药业股份有限公司',45.90,'盒','100','0.5g*36片',0),('m14126','银杏叶片(大)','片剂','贵州信邦制药股份有限公司',25.30,'盒','100','19.2mg*24片',0),('m14127','银杏叶片(小)','片剂','扬子江药业集团有限公司',25.50,'盒','100','9.6mg*36片',0),('m14128','左旋氨氯地平片','片剂','扬子江药业集团上海海尼药业有限公司',14.50,'盒','100','2.5mg*7片',0),('m14129','左旋氨氯地平片','片剂','施慧达药业集团（吉林）有限公司',34.80,'盒','100','2.5mg*14片',0),('m14130','左炔诺孕酮宫内节育器','其它','芬兰 Bayer Schering Pharma Oy(拜耳医药保健有限公司广州分公司分装)',1265.00,'盒','100','52mg',0),('m14131','沙丁胺醇气雾剂','气雾剂','Glaxo Wellcome S.A.',23.50,'支','100','100ug*200揿',0),('m14132','沙美特罗替卡松粉吸入剂','气雾剂','Glaxo Operations UK Limited',251.00,'盒','100','50ug/250ug*60喷',0),('m14133','环孢素软胶囊','软胶囊','丽珠集团丽珠制药厂',250.00,'盒','100','25mg*48粒',0),('m14134','硝呋太尔制霉素软胶囊','软胶囊','北京朗依制药有限公司',43.90,'盒','100','500mg:20ug*6粒',0),('m14135','复方聚乙二醇电解质散','散剂','深圳万和制药有限公司',42.90,'袋','100','68.56g',0),('m14136','蒙脱石散(J）','散剂','JK博福一益普生(天津)制药有限公司',22.20,'盒','100','3g*10袋',0),('m14137','脾氨肽口服冻干粉','散剂','大连百利天华制药有限公司',121.00,'盒','100','2mg*5瓶',0),('m14138','小儿牛黄清心散','散剂','山东方健制药有限公司',35.90,'盒','100','0.3g*8袋',0),('m14139','保妇康栓','栓剂','海南碧凯药业有限公司',26.30,'盒','100','1.74g*8粒',0),('m14140','博性康药膜','栓剂','贵州大华制药有限公司',29.80,'盒','100','5cm*7cm*12片',0),('m14141','地诺前列酮栓','栓剂','Controlled Therapeutics（Scotland）Limited',472.00,'盒','100','10mg',0),('m14142','复方角菜酸酯栓','栓剂','西安杨森制药有限公司',16.00,'盒','100','3.4g*6枚',0),('m14143','复方沙棘籽油栓','栓剂','陕西海天制药有限公司',33.00,'盒','100','2.7g*7粒',0),('m14144','甲硝唑呋喃唑酮栓','栓剂','哈药集团制药总厂',24.30,'盒','100','101.6mg*5粒',0),('m14145','康妇消炎栓','栓剂','葵花药业集团（伊春）有限公司',32.50,'盒','100','2.8g*9粒',0),('m14146','咪康唑栓','栓剂','法国Catalent France Beinheim S.A.',25.60,'盒','100','400mg*3粒',0),('m14147','咪康唑栓','栓剂','法国Catalent France Beinheim S.A',30.50,'盒','100','1200mg*1粒',0),('m14148','重组人干扰素a-2b栓','栓剂','安徽安科生物工程(集团)股份有限公司',52.90,'盒','100','10万u*10枚',0),('m14149','沙丁胺醇溶液','外用溶液','laxo Wellcome Operations',61.90,'瓶','100','100mg:20ml',0),('m14150','苯扎氯铵溶液','外用溶液剂','汕头保税区洛斯特制药有限公司',58.70,'瓶','100','150ml',0),('m14151','红核妇洁洗液','外用溶液剂','山东步长神州制药有限公司',32.60,'盒','100','10ml*10袋',0),('m14152','洁肤净洗液','外用溶液剂','西安仁仁药业有限公司',25.20,'盒','100','200ml',0),('m14153','皮肤康洗液','外用溶液剂','北京华洋奎龙药业有限公司',23.50,'盒','100','50ml',0),('m14154','阴痒康洗剂','外用溶液剂','河南润弘制药股份有限公司',35.40,'盒','100','160ml',0),('m14155','定坤丹','丸剂','山西广誉远国药有限公司',66.60,'盒','100','7g*6袋',0),('m14156','断血流滴丸','丸剂','甘肃益尔药业股份有限公司',44.90,'盒','100','3g*9袋',0),('m14157','固肾安胎丸','丸剂','北京勃然制药有限公司',54.40,'盒','100','6g*9袋',0),('m14158','桂附地黄丸','丸剂','河南省宛西制药股份有限公司',11.40,'盒','100','200粒',0),('m14159','六味地黄丸','丸剂','河南省宛西制药股份有限公司',11.50,'盒','100','200粒',0),('m14160','明目上清丸','丸剂','陕西利君现代中药有限公司',28.50,'盒','100','9g*8袋',0),('m14161','杞菊地黄丸','丸剂','河南省宛西制药股份有限公司',11.40,'盒','100','200粒',0),('m14162','速效救心丸','丸剂','天津中新药业集团股份有限公司第六中药厂',29.20,'盒','100','40mg*150s',0),('m14163','知柏地黄丸','丸剂','河南省宛西制药股份有限公司',11.40,'盒','100','200粒',0),('m14164','沙美特罗替卡松粉吸入剂','吸入剂','Glaxo Operations UK Limited',383.00,'盒','100','500ug*60吸',0),('m14165','妥布霉素地塞米松眼膏','眼膏','s.a.ALCON-COUVREUR n.v.',37.10,'支','100','3.5g',0),('m14166','妥布霉素眼膏','眼膏','s.a.ALCON-COUVREUR n.v.',30.40,'支','100','3.5g',0),('m14167','氧氟沙星眼膏','眼膏','沈阳兴齐眼药股份有限公司',17.80,'支','100','3.5g',0),('m14168','氧氟沙星眼膏(J)','眼膏','参天制药株式会社',28.40,'支','100','3.5g',0),('m14169','阿托品眼用凝胶','眼用凝胶','沈阳兴齐眼药股份有限公司',19.00,'支','100','2.5g',0),('m14170','更昔洛韦眼用凝胶','眼用凝胶','湖北科益药业股份有限公司',26.10,'支','100','5g',10),('m14171','卡波姆眼用凝胶','眼用凝胶','Dr.Gerhard Mann. Chem.-Pharm. Fabrik Gmbh',51.90,'支','100','20mg：10g',0),('m14172','维生素A棕榈酸酯眼用凝胶','眼用凝胶','沈阳兴齐眼药股份有限公司',34.70,'支','100','5g:5000IU',0),('m14173','小牛血去蛋白眼用凝胶','眼用凝胶','沈阳兴齐眼药股份有限公司',49.70,'支','100','5g',0),('m14174','重组牛碱性成纤维细胞生长因子眼用凝胶','眼用凝胶','珠海亿胜生物制药有限公司',41.20,'支','100','2.1万U:5g',0),('m14175','左氧氟沙星眼用凝胶','眼用凝胶','湖北远大天天明制药有限公司',19.90,'支','100','5g',0),('m14176','重组人干扰素a2b阴道泡腾胶囊','阴道泡腾胶囊','上海华新生物高技术有限公司',74.00,'盒','100','80万IU*4粒',0),('m14177','复方氨基酸注射液18AA-Ⅳ','针剂','广东利泰制药股份有限公司',59.10,'瓶','100','8.7g:250ml',0),('m14178','拉贝洛尔注射液','针剂','江苏迪赛诺制药有限公司',39.80,'支','100','50mg:10ml',0),('m14179','左氧氟沙星氯化钠注射液','针剂','扬子江药业集团有限公司',27.60,'瓶','100','0.2g:100ml',0),('m14180','氨碘肽注射液','注射剂','杭州国光药业有限公司',14.90,'支','100','2ml',0),('m14181','氨溴索葡萄糖注射液','注射剂','石家庄四药有限公司',11.80,'瓶','100','30mg:50ml',10),('m14182','胺碘酮注射液','注射剂','Sanofi Winthrop Industrie',30.00,'支','100','150mg:3ml',2),('m14183','昂丹司琼注射液','注射剂','威海爱威制药有限公司',37.10,'袋','100','8mg:100ml',3),('m14184','奥拉西坦注射液','注射剂','广东世信药业有限公司',67.70,'支','100','1g:5ml',0),('m14185','奥曲肽注射液(J)','注射剂','诺华Novartis Pharma Stein AG',116.00,'支','100','0.1mg:1ml',2),('m14186','奥曲肽注射液(国）','注射剂','国药一心制药有限公司',90.40,'支','100','0.2mg:1ml',12),('m14187','吡拉西坦氯化钠注射液','注射剂','山东威高药业股份有限公司',24.50,'瓶','100','10g: 50ml',2),('m14188','丙泊酚注射液(J)','注射剂','Corden Pharma S.P.A （意大利）',88.80,'支','100','0.2g:20ml',3),('m14189','丙泊酚注射液（国）','注射剂','四川国瑞药业有限责任公司',38.50,'支','100','0.2g:20ml',3),('m14190','玻璃酸钠注射液','注射剂','上海景峰制药有限公司',176.00,'支','100','25mg：2.5ml',4),('m14191','玻璃酸钠注射液','注射剂','日本生化学工业株式会社',218.00,'支','100','25mg:2.5ml',1),('m14192','参麦注射液','注射剂','四川升和药业股份有限公司',24.90,'支','100','20ml',2),('m14193','参芎葡萄糖注射液','注射剂','贵州景峰注射剂有限公司',56.40,'瓶','100','0.12g:100ml',4),('m14194','长春西汀葡萄糖注射液（玻）','注射剂','华仁药业（日照）有限公司',24.70,'瓶','100','10mg:100ml',2),('m14195','丹参川芎嗪注射液','注射剂','贵州拜特制药有限公司',45.40,'支','100','5ml',1),('m14196','单硝酸异山梨酯注射液','注射剂','鲁南贝特制药有限公司',29.10,'支','100','20mg:5ml',2),('m14197','灯盏细辛注射液','注射剂','云南生物谷药业股份有限公司',22.50,'支','100','45mg:10ml',4),('m14198','地特胰岛素注射液（特充）','注射剂','诺和诺德（中国）制药有限公司',237.00,'支','100','300U：3ml',1),('m14199','碘佛醇注射液','注射剂','江苏恒瑞医药股份有限公司',78.80,'瓶','100','13.56g:20ml',5),('m14200','碘佛醇注射液','注射剂','tyco Heal thcare',381.00,'瓶','100','35g:100ml',3),('m14201','碘海醇注射液','注射剂','扬子江药业集团有限公司',160.00,'瓶','100','15g:50ml',25),('m14202','碘海醇注射液','注射剂','扬子江药业集团有限公司',272.00,'瓶','100','30g:100ml',23),('m14203','碘克沙醇注射液','注射剂','GE Healthcare Ireland',756.00,'瓶','100','32g:100ml',2),('m14204','多索茶碱注射液','注射剂','黑龙江福和华星制药集团股份有限公司',15.60,'支','100','0.1g:10ml',5),('m14205','多西他赛注射液','注射剂','江苏恒瑞医药股份有限公司',472.00,'支','100','20mg：0.5ml',2),('m14206','多烯磷酯酰胆碱注射液','注射剂','成都天台山制药有限公司',25.30,'支','100','232.5mg:5ml',3),('m14207','多种微量元素注射液','注射剂','华瑞制药有限公司',13.50,'支','100','10ml',4),('m14208','复方氨基酸注射液18AA-II','注射剂','华瑞制药有限公司',26.70,'瓶','100','8.5%:250ml',2),('m14209','复方樟柳碱注射液','注射剂','华润紫竹药业有限公司',23.00,'支','100','2mg:2ml',4),('m14210','钆喷酸葡胺注射液','注射剂','广州康臣药业有限公司',169.00,'支','100','20ml:9.38g',0),('m14211','钆喷酸葡胺注射液','注射剂','德国 Bayer Schering Pharma AG (拜耳医药保健有限公司广州分公司分装)',194.00,'瓶','100','469.01mg/ml*15ml',0),('m14212','甘精胰岛素注射液','注射剂','Sanofi-Aventis Deutschland GmbH',237.00,'支','100','300u:3ml',0),('m14213','甘舒霖30R笔芯','注射剂','通化东宝药业股份有限公司',56.20,'支','100','300IU:3ml',0),('m14214','甘舒霖N笔芯','注射剂','通化东宝药业股份有限公司',56.20,'支','100','300U:3ml',0),('m14215','甘舒霖R笔芯','注射剂','通化东宝药业股份有限公司',56.20,'支','100','300U:3ml',0),('m14216','甘油果糖氯化钠注射液','注射剂','四川科伦药业股份有限公司',24.20,'袋','100','250ml',0),('m14217','格拉司琼葡萄糖注射液','注射剂','江苏晨牌药业集团股份有限公司',22.90,'瓶','100','3mg:50ml',0),('m14218','桂哌齐特注射液','注射剂','北京四环制药有限公司',49.00,'支','100','80mg:2ml',0),('m14219','果糖注射液','注射剂','江苏正大丰海制药有限公司',30.80,'瓶','100','12.5g:250ml',0),('m14220','红花注射液','注射剂','山西华卫药业有限公司',20.80,'支','100','10ml',0),('m14221','混合糖电解质注射液','注射剂','江苏正大丰海制药有限公司',124.00,'瓶','100','500ml',0),('m14222','卡贝缩宫素注射液','注射剂','Ferring Inc',298.00,'支','100','100ug:1ml',0),('m14223','卡前列素氨丁三醇注射液','注射剂','Pharmacia & Upjohn Company',537.00,'支','100','250ug:1ml',0),('m14224','苦碟子注射液','注射剂','通化华夏药业有限责任公司',21.30,'支','100','250mg:10ml',0),('m14225','利奈唑胺注射液','注射剂','挪威 Fresenius Kabi Norge AS',453.00,'袋','100','0.6g:300ml',0),('m14226','利托君注射液','注射剂','广东先强药业股份有限公司',35.20,'支','100','50mg:5ml',0),('m14227','硫辛酸注射液','注射剂','亚宝药业集团股份有限公司',33.20,'支','100','0.15g:6ml',0),('m14228','罗哌卡因注射液','注射剂','Astrazeneca AB （瑞典））',57.00,'支','100','0.1g:10ml',0),('m14229','莫西沙星氯化钠注射液','注射剂','德国 Bayer Schering Pharma AG(拜耳医药保健有限公司分装)',316.00,'瓶','100','0.4g:250ml',0),('m14230','诺和灵30R笔芯','注射剂','诺和诺德（中国）制药有限公司',63.30,'支','100','300u:3ml',0),('m14231','诺和灵N笔芯','注射剂','诺和诺德（中国）制药有限公司',63.30,'支','100','300u:3ml',0),('m14232','诺和灵R笔芯','注射剂','诺和诺德（中国）制药有限公司',63.30,'支','100','300u:3ml',0),('m14233','诺和锐30笔芯','注射剂','诺和诺德（中国）制药有限公司',85.20,'支','100','300u:3ml',0),('m14234','诺和锐30特充','注射剂','诺和诺德（中国）制药有限公司',100.00,'支','100','300u:3ml',0),('m14235','诺和锐笔芯','注射剂','诺和诺德（中国）制药有限公司',85.20,'支','100','300u:3ml',0),('m14236','诺和锐特充','注射剂','诺和诺德（中国）制药有限公司',100.00,'支','100','300u:3ml',0),('m14237','七氟烷注射液','注射剂','上海恒瑞医药有限公司',991.00,'瓶','100','120ml',0),('m14238','前列地尔注射液','注射剂','哈药集团生物工程有限公司',119.00,'支','100','10ug:2ml',0),('m14239','曲普瑞林注射液','注射剂','Ferring AG',137.00,'支','100','0.1mg:1ml',0),('m14240','神经节苷脂注射液(S)','注射剂','JK齐鲁制药有限公司',126.00,'支','100','20mg:2ml',0),('m14241','疏血通注射液','注射剂','牡丹江友博药业股份有限公司',40.30,'支','100','2ml',0),('m14242','舒血宁注射液','注射剂','黑龙江珍宝岛药业股份有限公司',20.70,'支','100','5ml',0),('m14243','缩宫素注射液(生物提取)','注射剂','安徽宏业药业有限公司',13.00,'支','100','5U：1ml',0),('m14244','替罗非班氯化钠注射液','注射剂','远大医药（中国）有限公司',358.00,'瓶','100','5mg:100ml',0),('m14245','天麻素注射液','注射剂','昆明制药集团股份有限公司',20.70,'支','100','2ml',0),('m14246','托烷司琼注射液','注射剂','西南药业股份有限公司',48.20,'支','100','2mg:2ml',0),('m14247','乌拉地尔注射液','注射剂','西安利君制药有限责任公司',31.60,'支','100','25mg:5ml',0),('m14248','硝酸异山梨酯注射液(J)','注射剂','德国许瓦兹制药集团',16.90,'支','100','10mg:10ml',0),('m14249','小儿复方氨基酸注射液','注射剂','天津金耀药业有限公司',18.80,'支','100','20ml',10),('m14250','小牛血清去蛋白注射液','注射剂','锦州奥鸿药业有限责任公司',46.10,'支','100','0.2g:5ml',1),('m14251','小牛血清去蛋白注射液','注射剂','锦州奥鸿药业有限责任公司',78.30,'支','100','0.4g:10ml',1),('m14252','醒脑静注射液','注射剂','无锡济民可信山禾药业股份有限公司',57.50,'支','100','10ml',2),('m14253','依达拉奉注射液','注射剂','南京先声东元制药有限公司',46.00,'支','100','10mg:5ml',4),('m14254','依达拉奉注射液','注射剂','河北医科大学生物医学工程中心',63.00,'支','100','30mg:20ml',2),('m14255','依托泊苷注射液','注射剂','江苏恒瑞医药股份有限公司',13.80,'支','100','0.1g:5ml',5),('m14256','胰岛素注射液','注射剂','江苏万邦生化医药股份有限公司',19.60,'支','100','400u:10ml',3),('m14257','银杏达莫注射液','注射剂','通化谷红制药有限公司',25.30,'支','100','10ml',2),('m14258','荧光素钠注射液','注射剂','广西梧州制药(集团)股份有限公司',92.00,'支','100','0.6g:3ml',0),('m14259','优泌乐50R笔芯','注射剂','Lilly France S.A.S.',85.20,'盒','100','300IU:3ml',0),('m14260','优泌林70/30笔芯','注射剂','Lilly France',63.30,'支','100','300IU:3ml',0),('m14261','优泌林R笔芯','注射剂','Lilly France',63.30,'支','100','300IU:3ml',0),('m14262','蔗糖铁注射液','注射剂','成都天台山制药有限公司',64.50,'支','100','100mg：5ml',0),('m14263','脂溶性维生素注射液','注射剂','华瑞制药有限公司',12.90,'支','100','10ml',0),('m14264','重组促卵泡素β注射液','注射剂','N.V.Organon',233.00,'支','100','50IU:0.5ML',20),('m14265','重组促卵泡素β注射液','注射剂','N.V.Organon',397.00,'支','100','100IU:0.5ml',0),('m14266','重组甘精胰岛素注射液','注射剂','甘李药业股份有限公司',178.00,'支','100','300u:3ml',0),('m14267','重组人促红素注射液','注射剂','深圳赛保尔生物药业有限公司',42.50,'支','100','4000U:1ml',0),('m14268','重组人粒细胞刺激因子注射液','注射剂','上海三维生物技术有限公司',78.90,'支','62','150ug',38),('m14269','重组人粒细胞刺激因子注射液','注射剂','齐鲁制药有限公司',122.00,'支','100','100 ug:0.6ml',0),('m14270','注射用阿莫西林钠克拉维酸钾','注射剂','华北制药股份有限公司',21.00,'支','100','0.6g',0),('m14271','左卡尼汀注射液','注射剂','东北制药集团沈阳第一制药有限公司',42.60,'支','100','1g:5ml',0),('m14272','左氧氟沙星氯化钠注射液','注射剂','浙江医药股份有限公司新昌制药厂',39.80,'袋','100','0.3g:100ml',0),('m14273','30%脂肪乳注射液','注射液','西安力邦制药有限公司',32.90,'瓶','100','30%:100ml',0);
/*!40000 ALTER TABLE `medicine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_histories`
--

DROP TABLE IF EXISTS `medicine_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine_histories` (
  `mrid` int unsigned NOT NULL AUTO_INCREMENT COMMENT '用药记录',
  `patient_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `mid` varchar(255) DEFAULT NULL,
  `numb` int unsigned DEFAULT NULL,
  `orders` varchar(255) DEFAULT NULL,
  `time` date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `wid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mrid`),
  KEY `fk_id_mr` (`patient_id`),
  KEY `fk_rid_mr` (`patient_id`),
  KEY `fk_mid` (`mid`),
  KEY `medicine_hp` (`wid`),
  CONSTRAINT `medicine_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `medicine_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_medicine` FOREIGN KEY (`mid`) REFERENCES `medicine` (`mid`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine_histories`
--

LOCK TABLES `medicine_histories` WRITE;
/*!40000 ALTER TABLE `medicine_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicine_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_relationship`
--

DROP TABLE IF EXISTS `medicine_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine_relationship` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用药记录与门诊、住院、急救的关系',
  `mrid` int unsigned DEFAULT NULL,
  `record_id` int DEFAULT '10010',
  `case_id` int DEFAULT '10300',
  `operation_id` int DEFAULT '20202',
  PRIMARY KEY (`id`),
  KEY `to_case` (`case_id`),
  KEY `to_medicine_histories` (`mrid`),
  KEY `to_record` (`record_id`),
  KEY `to_operation` (`operation_id`),
  CONSTRAINT `to_case` FOREIGN KEY (`case_id`) REFERENCES `case_histories` (`case_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_medicine_histories` FOREIGN KEY (`mrid`) REFERENCES `medicine_histories` (`mrid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_operation` FOREIGN KEY (`operation_id`) REFERENCES `operation_histories` (`operation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_record` FOREIGN KEY (`record_id`) REFERENCES `medical_record` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine_relationship`
--

LOCK TABLES `medicine_relationship` WRITE;
/*!40000 ALTER TABLE `medicine_relationship` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicine_relationship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_histories`
--

DROP TABLE IF EXISTS `operation_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_histories` (
  `operation_id` int NOT NULL AUTO_INCREMENT COMMENT '急救用表',
  `patient_id` varchar(255) DEFAULT NULL,
  `aid` int DEFAULT NULL COMMENT '对应救护车',
  PRIMARY KEY (`operation_id`),
  KEY `operation_patient` (`patient_id`),
  KEY `operation_ambu` (`aid`),
  CONSTRAINT `operation_ambu` FOREIGN KEY (`aid`) REFERENCES `ambulance` (`aid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `operation_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20203 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_histories`
--

LOCK TABLES `operation_histories` WRITE;
/*!40000 ALTER TABLE `operation_histories` DISABLE KEYS */;
INSERT INTO `operation_histories` VALUES (20202,NULL,NULL);
/*!40000 ALTER TABLE `operation_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_relating`
--

DROP TABLE IF EXISTS `operation_relating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_relating` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '急救相关人员信息记录',
  `operation_id` int DEFAULT NULL,
  `wid` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `operation_hp` (`wid`),
  KEY `to_operationhis` (`operation_id`),
  CONSTRAINT `operation_hp` FOREIGN KEY (`wid`) REFERENCES `health_personnel` (`wid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_operationhis` FOREIGN KEY (`operation_id`) REFERENCES `operation_histories` (`operation_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_relating`
--

LOCK TABLES `operation_relating` WRITE;
/*!40000 ALTER TABLE `operation_relating` DISABLE KEYS */;
/*!40000 ALTER TABLE `operation_relating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `name` varchar(255) NOT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `idType` varchar(255) DEFAULT NULL,
  `telno` varchar(50) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `ethnicity` varchar(255) DEFAULT NULL,
  `patient_id` varchar(255) NOT NULL,
  PRIMARY KEY (`patient_id`) USING BTREE,
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES ('张三',NULL,NULL,NULL,'测试用户',NULL,'123123123412341234'),('Mark','male','身份证','12345678912','string','string','789789200101251234');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'??','lisi@example.com'),(3,'??','wangwu@example.com'),(4,'testtest','testtest@unity.cn'),(5,'1232313','2463955195@qq.com');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-24 18:36:43
