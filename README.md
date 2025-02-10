AmbuSmart
├─ .env
├─ .ipynb_checkpoints
│  ├─ huggingface-checkpoint.ipynb
│  ├─ main-checkpoint.py
│  └─ Untitled-checkpoint.ipynb
├─ app
│  ├─ api
│  │  ├─ ambulance
│  │  │  ├─ ambulance_routers.py
│  │  │  ├─ basic_check_routers.py
│  │  │  └─ operation_histories_routers.py
│  │  ├─ chat.py
│  │  ├─ check
│  │  │  ├─ check_histories_routers.py
│  │  │  └─ check_routers.py
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
│  │  ├─ users.py
│  │  └─ __init__.py
│  ├─ core
│  │  ├─ config.py
│  │  ├─ logger.py
│  │  └─ __init__.py
│  ├─ crud
│  │  ├─ ambulance
│  │  │  ├─ basic_check.py
│  │  │  ├─ crud_ambulance.py
│  │  │  └─ crud_operation_history.py
│  │  ├─ case_history.py
│  │  ├─ check
│  │  │  ├─ check_crud.py
│  │  │  └─ check_histories_crud.py
│  │  ├─ crud_allergy.py
│  │  ├─ crud_department.py
│  │  ├─ crud_patient.py
│  │  ├─ health_personnel.py
│  │  ├─ medical_history.py
│  │  ├─ medical_record.py
│  │  ├─ medicine
│  │  │  ├─ medicine_crud.py
│  │  │  └─ medicine_histories_crud.py
│  │  └─ __init__.py
│  ├─ db
│  │  ├─ base.py
│  │  ├─ session.py
│  │  └─ __init__.py
│  ├─ main.py
│  ├─ models
│  │  ├─ allergy.py
│  │  ├─ ambulance.py
│  │  ├─ basic_check.py
│  │  ├─ case_history.py
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
│  │  ├─ users.py
│  │  └─ __init__.py
│  ├─ schemas
│  │  ├─ allergy.py
│  │  ├─ ambulance
│  │  │  ├─ ambulance.py
│  │  │  ├─ basic_check.py
│  │  │  └─ operation_history.py
│  │  ├─ case_history.py
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
│  │  ├─ patient.py
│  │  └─ __init__.py
│  ├─ services
│  │  ├─ allergy_service.py
│  │  ├─ ambulance
│  │  │  ├─ ambulance.py
│  │  │  ├─ basic_check.py
│  │  │  └─ operation_histories_sevice.py
│  │  ├─ case_history_service.py
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
│  │  ├─ patient_service.py
│  │  └─ __init__.py
│  ├─ tests
│  │  └─ __init__.py
│  ├─ utils
│  │  ├─ database_backup0208.sql
│  │  ├─ requirements.txt
│  │  └─ __init__.py
│  └─ __init__.py
├─ data.txt
├─ frontend
│  ├─ babel.config.js
│  ├─ jsconfig.json
│  ├─ package-lock.json
│  ├─ package.json
│  ├─ public
│  │  ├─ favicon.ico
│  │  └─ index.html
│  ├─ README.md
│  ├─ src
│  │  ├─ App.vue
│  │  ├─ assets
│  │  │  └─ logo.png
│  │  ├─ components
│  │  ├─ main.js
│  │  ├─ router
│  │  │  ├─ index.js
│  │  │  └─ modules
│  │  ├─ services
│  │  │  └─ userService.js
│  │  ├─ store
│  │  │  ├─ index.js
│  │  │  └─ user.js
│  │  ├─ utils
│  │  └─ views
│  │     ├─ Chat.vue
│  │     ├─ HelloWorld.vue
│  │     ├─ HomePage.vue
│  │     ├─ test.vue
│  │     └─ UserManagement.vue
│  ├─ vite.config.js
│  └─ vue.config.js
├─ huggingface.ipynb
├─ README.md
├─ requirements.txt
└─ Untitled.ipynb