# Salesforce AI Fraud Case Triage Agent

A Salesforce DX demo project that analyzes suspicious transactions using AI-powered fraud risk assessment, asynchronous Apex processing, Queueable jobs, Lightning Web Components (LWC), and external OpenAI integration.

This project demonstrates:

* Apex development
* Lightning Web Components (LWC)
* Queueable Apex
* HTTP callouts
* OpenAI API integration
* JSON parsing
* Permission-set-driven security
* Scratch org deployment
* Salesforce DX unlocked packaging workflows

---

# Features

* Custom Lightning Web Component on Fraud Case record pages
* Analyze Fraud Risk button for AI-powered fraud analysis
* OpenAI integration using HTTP callouts
* Queueable Apex asynchronous processing
* Structured AI response parsing
* Fraud risk scoring and recommendations
* AI audit/history tracking
* Permission-set-driven access
* Non-admin user support
* Scratch-org deployable architecture
* Unlocked package validation

---

# Architecture

```text
LWC (fraudRiskAnalyzer)
    ↓
FraudRiskAnalyzerController
    ↓
FraudAnalysisQueueable
    ↓
FraudAnalysisService
    ↓
OpenAIHttpService
    ↓
HttpCalloutService
    ↓
OpenAI API
```

---

# Technologies Used

* Salesforce DX
* Apex
* Lightning Web Components (LWC)
* Queueable Apex
* HTTP Callouts
* OpenAI API
* Custom Objects
* Permission Sets
* FlexiPages
* Scratch Orgs
* Git / GitHub
* Unlocked Packages

---

# Project Structure

```text
force-app/main/default/
│
├── classes/
├── lwc/
├── objects/
├── permissionsets/
├── flexipages/
├── tabs/
├── layouts/
└── namedCredentials/
```

---

# Main Components

## Apex Classes

| Class                           | Purpose                         |
| ------------------------------- | ------------------------------- |
| FraudRiskAnalyzerController     | Entry point for LWC actions     |
| FraudAnalysisQueueable          | Async fraud analysis processing |
| FraudAnalysisService            | Fraud analysis business logic   |
| OpenAIHttpService               | OpenAI integration logic        |
| HttpCalloutService              | Reusable HTTP utility layer     |
| FraudAnalysisResult             | DTO for parsed AI response      |
| FraudAnalysisQueueableTest      | Queueable test coverage         |
| FraudAnalysisServiceTest        | Service test coverage           |
| FraudRiskAnalyzerControllerTest | Controller test coverage        |

---

# Custom Objects

## Fraud_Case__c

Stores:

* suspicious transaction details
* customer information
* AI risk level
* AI-generated summary
* recommended action
* fraud review status

---

## AI_Fraud_Analysis__c

Stores:

* AI prompt
* AI response JSON
* parsed recommendation
* parsed risk level
* user feedback
* audit/history tracking

---

# Screenshots

## Fraud Case Record Page

Shows:

* Analyze Fraud Risk button
* AI Risk Level
* AI Summary
* Recommended Action

<img width="1167" height="526" alt="image" src="https://github.com/user-attachments/assets/3df16be3-443b-44ee-9770-7ee62470a68a" />

---

## AI Fraud Analysis Related Records

<img width="648" height="613" alt="image" src="https://github.com/user-attachments/assets/eac5c5b5-33f1-4a29-a405-f8fd8a8c8a1b" />

---

## Apex Test Results

<img width="582" height="640" alt="image" src="https://github.com/user-attachments/assets/1a33c638-590a-4424-b9f7-c48ec0c1ae32" />

---

## Permission Set Configuration

<img width="1490" height="517" alt="image" src="https://github.com/user-attachments/assets/f4bf0271-b254-4790-80da-635434d37add" />
<img width="1532" height="555" alt="image" src="https://github.com/user-attachments/assets/6b62cf4f-2cc2-4e8d-91c4-46fe368df465" />

---

## Non-Admin User Access

<img width="1235" height="570" alt="image" src="https://github.com/user-attachments/assets/3c0d98a2-b576-461c-907b-ac8536565540" />

---

# Setup Instructions

## 1. Create Scratch Org

```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias FraudScratch
```

---

## 2. Deploy Metadata

```bash
sf project deploy start --target-org FraudScratch
```

---

## 3. Assign Permission Set

```bash
sf org assign permset --name Fraud_Analyst_Access --target-org FraudScratch
```

---

## 4. Open Org

```bash
sf org open --target-org FraudScratch
```

---

# OpenAI Configuration

This demo project uses OpenAI Responses API integration.

## Create Named Credential

Setup → Named Credentials

Create:

* Label: OpenAI API
* Name: OpenAI_API
* URL: https://api.openai.com

Authentication:

* Identity Type: Named Principal
* Authentication Protocol: No Authentication

---

# API Key Configuration

For demo/scratch-org simplicity and reduced configuration overhead, the API key is temporarily hardcoded in Apex.

In a production implementation, the API key should be stored securely using:

* External Credentials
* Named Credentials with custom headers
* Salesforce Secret Manager
* Protected Custom Metadata

---

# Post-Deployment Configuration

## Activate Lightning Record Page

After deployment:

Activate:

* Fraud Case Record Page

as:

* Org Default

because FlexiPage assignments may not reliably carry across org deployments.

---

# Required Permissions

Users require:

## Fraud_Case__c Object

* Read
* Create
* Edit

## AI_Fraud_Analysis__c Object

* Read
* Create
* Edit

---

# Required Tab Visibility

Users need:

* Fraud Cases tab visibility set to Visible

---

# Required App Access

Non-admin users require access to the Sales app (or whichever app contains the Fraud Cases tab).

---

# Required Apex Class Access

The permission set includes access to:

* FraudRiskAnalyzerController
* FraudAnalysisQueueable
* FraudAnalysisService
* OpenAIHttpService
* HttpCalloutService
* FraudAnalysisResult

---

# Running Tests

```bash
sf apex run test --test-level RunLocalTests --target-org FraudScratch --result-format human --code-coverage --synchronous
```

---

# Test Coverage

* 100% test pass rate
* Async queueable coverage included
* Controller/service separation validated

---

# Packaging

This project was validated using Salesforce DX unlocked packaging through a Dev Hub.

## Create Package

```bash
sf package create --name FraudTriagePackage --package-type Unlocked --path force-app --target-dev-hub DevHub
```

---

## Create Package Version

```bash
sf package version create --package FraudTriagePackage --installation-key-bypass --wait 20 --target-dev-hub DevHub
```

---

## Install Package

```bash
sf package install --package YOUR_04T_PACKAGE_ID --target-org FraudScratch --wait 20 --publish-wait 10
```

---

# Validation Checklist

After deployment verify:

* Fraud Cases tab appears
* Fraud Risk Analyzer component appears
* Analyze Fraud Risk button works
* AI response is generated
* Fraud Case updates correctly
* AI_Fraud_Analysis__c records are created
* Queueable job executes successfully
* Non-admin users can access functionality

---

# Demo Purpose

This project was built as a demonstration of:

* Salesforce AI integration architecture
* asynchronous Apex processing
* Queueable Apex patterns
* Lightning Web Component development
* external AI HTTP callouts
* structured JSON parsing
* permission-set-driven access management
* Salesforce DX project structure
* unlocked packaging workflows


