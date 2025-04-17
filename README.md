
```
AmbuSmart
├─ .env
├─ README.md
├─ app
│  ├─ __init__.py
│  ├─ api
│  │  ├─ __init__.py
│  │  ├─ ambulance
│  │  │  ├─ ambulance_routers.py
│  │  │  ├─ basic_check_routers.py
│  │  │  └─ operation_histories_routers.py
│  │  ├─ audio_router.py
│  │  ├─ chat.py
│  │  ├─ chat_router.py
│  │  ├─ check
│  │  │  ├─ check_histories_routers.py
│  │  │  └─ check_routers.py
│  │  ├─ knowledgeGraph.py
│  │  ├─ medicine
│  │  │  ├─ medicine_histories_routers.py
│  │  │  └─ medicine_routers.py
│  │  ├─ patient
│  │  │  ├─ allergy_routers.py
│  │  │  ├─ medical_history_routers.py
│  │  │  └─ patient_routers.py
│  │  ├─ personnel
│  │  │  ├─ department_routers.py
│  │  │  └─ health_personnel_router.py
│  │  ├─ record
│  │  │  ├─ case_history_routers.py
│  │  │  └─ medical_record_routers.py
│  │  └─ users.py
│  ├─ core
│  │  ├─ __init__.py
│  │  ├─ config.py
│  │  └─ logger.py
│  ├─ crud
│  │  ├─ __init__.py
│  │  ├─ ambulance
│  │  │  ├─ basic_check.py
│  │  │  ├─ crud_ambulance.py
│  │  │  └─ crud_operation_history.py
│  │  ├─ case_history.py
│  │  ├─ chat.py
│  │  ├─ check
│  │  │  ├─ check_crud.py
│  │  │  └─ check_histories_crud.py
│  │  ├─ crud_allergy.py
│  │  ├─ crud_department.py
│  │  ├─ crud_patient.py
│  │  ├─ health_personnel.py
│  │  ├─ medical_history.py
│  │  ├─ medical_record.py
│  │  └─ medicine
│  │     ├─ medicine_crud.py
│  │     └─ medicine_histories_crud.py
│  ├─ db
│  │  ├─ __init__.py
│  │  ├─ base.py
│  │  └─ session.py
│  ├─ main.py
│  ├─ models
│  │  ├─ __init__.py
│  │  ├─ allergy.py
│  │  ├─ ambulance.py
│  │  ├─ basic_check.py
│  │  ├─ case_history.py
│  │  ├─ chat.py
│  │  ├─ check
│  │  │  ├─ check.py
│  │  │  ├─ check_histories.py
│  │  │  └─ check_relationship.py
│  │  ├─ department.py
│  │  ├─ health_personnel.py
│  │  ├─ medical_history.py
│  │  ├─ medical_record.py
│  │  ├─ medicine
│  │  │  ├─ medicine.py
│  │  │  ├─ medicine_histories.py
│  │  │  └─ medicine_relationship.py
│  │  ├─ message.py
│  │  ├─ operation_history.py
│  │  ├─ patient.py
│  │  └─ users.py
│  ├─ schemas
│  │  ├─ __init__.py
│  │  ├─ allergy.py
│  │  ├─ ambulance
│  │  │  ├─ ambulance.py
│  │  │  ├─ basic_check.py
│  │  │  └─ operation_history.py
│  │  ├─ case_history.py
│  │  ├─ chat.py
│  │  ├─ check
│  │  │  ├─ check.py
│  │  │  ├─ check_histories.py
│  │  │  └─ check_relationship.py
│  │  ├─ department.py
│  │  ├─ health_personnel.py
│  │  ├─ medical_history.py
│  │  ├─ medical_record.py
│  │  ├─ medicine
│  │  │  ├─ medicine.py
│  │  │  ├─ medicine_histories.py
│  │  │  └─ medicine_relationship.py
│  │  └─ patient.py
│  ├─ services
│  │  ├─ __init__.py
│  │  ├─ allergy_service.py
│  │  ├─ ambulance
│  │  │  ├─ ambulance.py
│  │  │  ├─ basic_check.py
│  │  │  └─ operation_histories_sevice.py
│  │  ├─ case_history_service.py
│  │  ├─ chat_service.py
│  │  ├─ check
│  │  │  ├─ check_histories_service.py
│  │  │  └─ check_service.py
│  │  ├─ department_service.py
│  │  ├─ gpt_service.py
│  │  ├─ health_personnel.py
│  │  ├─ medical_history_service.py
│  │  ├─ medical_record_service.py
│  │  ├─ medicine
│  │  │  ├─ medicine_histories_service.py
│  │  │  └─ medicine_service.py
│  │  └─ patient_service.py
│  ├─ tests
│  │  └─ __init__.py
│  └─ utils
│     ├─ __init__.py
│     ├─ database_backup0325.sql
│     ├─ database_backup0330.sql
│     ├─ prompts.py
│     └─ requirements.txt
├─ data.txt
├─ frontend
│  ├─ .env
│  ├─ README.md
│  ├─ babel.config.js
│  ├─ jsconfig.json
│  ├─ package-lock.json
│  ├─ package.json
│  ├─ public
│  │  ├─ favicon.ico
│  │  ├─ icon
│  │  │  ├─ exit.png
│  │  │  └─ map.png
│  │  └─ index.html
│  ├─ src
│  │  ├─ App.vue
│  │  ├─ assets
│  │  │  └─ logo.png
│  │  ├─ components
│  │  │  ├─ CoreButtoms
│  │  │  │  ├─ KeywordsGraph.vue
│  │  │  │  ├─ PatientInfo.vue
│  │  │  │  ├─ basicCheckDialogue.vue
│  │  │  │  ├─ caseHistoryTable.vue
│  │  │  │  ├─ medicalRecordTable.vue
│  │  │  │  ├─ operationHistoryTable.vue
│  │  │  │  ├─ scoreTableDialogue.vue
│  │  │  │  └─ timeLineButtom.vue
│  │  │  ├─ Independent.jsx
│  │  │  ├─ MyReactComponent.jsx
│  │  │  ├─ NavigationBars.vue
│  │  │  ├─ ScoreValueForm
│  │  │  │  ├─ CerebralStroke.vue
│  │  │  │  ├─ GcsScore.vue
│  │  │  │  ├─ KillipScore.vue
│  │  │  │  └─ TiScore.vue
│  │  │  ├─ Stat
│  │  │  │  ├─ ChatWordCloud.vue
│  │  │  │  ├─ ConsistencyAnalysis.vue
│  │  │  │  ├─ FormSection.vue
│  │  │  │  ├─ SmartAdvice.vue
│  │  │  │  └─ WordCloudChart.vue
│  │  │  └─ utils
│  │  │     ├─ ExitComponent.vue
│  │  │     ├─ KnowledgeGraph.vue
│  │  │     ├─ mapComponent.vue
│  │  │     └─ withAliyunASR.jsx
│  │  ├─ main.js
│  │  ├─ router
│  │  │  └─ index.js
│  │  ├─ services
│  │  │  ├─ api.js
│  │  │  └─ userService.js
│  │  ├─ store
│  │  │  └─ index.js
│  │  └─ views
│  │     ├─ AmbuCore.vue
│  │     ├─ AmbuFin.vue
│  │     ├─ AmbuMenu.vue
│  │     ├─ AmbuPatientInfo.vue
│  │     ├─ AmbuStart.vue
│  │     ├─ AmbuStat.vue
│  │     ├─ Chat.vue
│  │     ├─ HelloWorld.vue
│  │     ├─ HomePage.vue
│  │     ├─ UserManagement.vue
│  │     └─ test.vue
│  └─ vue.config.js
└─ huggingface.ipynb

```