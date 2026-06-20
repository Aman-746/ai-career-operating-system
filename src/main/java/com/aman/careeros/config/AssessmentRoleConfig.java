package com.aman.careeros.config;

import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * AssessmentRoleConfig - Maps each target role to its assessment configuration.
 *
 * Topics are derived from the targetRole only (V1 design decision). Current
 * role
 * is stored in OnboardingProfile for future gap analysis but does not affect
 * the assessment topic set in this version.
 *
 * The DEFAULT entry covers any role string that doesn't match the curated list,
 * so the endpoint never returns null config data.
 */
@Component
public class AssessmentRoleConfig {

        public record TopicConfig(List<String> topics, int questionCount, int estimatedMinutes) {
        }

        private static final TopicConfig DEFAULT = new TopicConfig(
                        List.of("Core Technical Concepts", "Problem Solving", "Communication",
                                        "Professional Practices"),
                        30, 20);

        private static final Map<String, TopicConfig> ROLE_CONFIGS = Map.ofEntries(

                        Map.entry("Software Engineer", new TopicConfig(
                                        List.of(
                                                        "Data Structures & Algorithms",
                                                        "System Design",
                                                        "Object-Oriented Design",
                                                        "Databases & SQL",
                                                        "Concurrency"),
                                        30, 20)),

                        Map.entry("Frontend Engineer", new TopicConfig(
                                        List.of(
                                                        "JavaScript & TypeScript",
                                                        "React Ecosystem",
                                                        "CSS & Styling",
                                                        "Browser APIs & Performance",
                                                        "Accessibility"),
                                        30, 20)),

                        Map.entry("Backend Engineer", new TopicConfig(
                                        List.of(
                                                        "API Design",
                                                        "Database Design",
                                                        "System Design",
                                                        "Security Fundamentals",
                                                        "Distributed Systems"),
                                        30, 20)),

                        Map.entry("Full Stack Engineer", new TopicConfig(
                                        List.of(
                                                        "Frontend Architecture",
                                                        "Backend Architecture",
                                                        "Database Design",
                                                        "API Integration",
                                                        "Deployment & DevOps"),
                                        35, 23)),

                        Map.entry("Mobile Engineer (Android)", new TopicConfig(
                                        List.of(
                                                        "Kotlin & Jetpack Compose",
                                                        "Android Architecture",
                                                        "Background Processing",
                                                        "App Performance",
                                                        "Google Play Distribution"),
                                        30, 20)),

                        Map.entry("Mobile Engineer (iOS)", new TopicConfig(
                                        List.of(
                                                        "Swift & SwiftUI",
                                                        "iOS Architecture Patterns",
                                                        "UIKit",
                                                        "App Performance",
                                                        "App Store Distribution"),
                                        30, 20)),

                        Map.entry("DevOps / Platform Engineer", new TopicConfig(
                                        List.of(
                                                        "CI/CD Pipelines",
                                                        "Docker & Kubernetes",
                                                        "Infrastructure as Code",
                                                        "Monitoring & Observability",
                                                        "Cloud Platforms"),
                                        30, 20)),

                        Map.entry("Cloud Engineer", new TopicConfig(
                                        List.of(
                                                        "Cloud Architecture",
                                                        "Networking Fundamentals",
                                                        "Infrastructure as Code",
                                                        "Security & IAM",
                                                        "Monitoring & Reliability"),
                                        30, 20)),

                        Map.entry("Site Reliability Engineer", new TopicConfig(
                                        List.of(
                                                        "System Reliability",
                                                        "Incident Management",
                                                        "Observability",
                                                        "Capacity Planning",
                                                        "Automation"),
                                        30, 20)),

                        Map.entry("ML / AI Engineer", new TopicConfig(
                                        List.of(
                                                        "Machine Learning Fundamentals",
                                                        "Deep Learning",
                                                        "LLMs & Prompt Engineering",
                                                        "Model Evaluation & Metrics",
                                                        "MLOps"),
                                        35, 25)),

                        Map.entry("Data Scientist", new TopicConfig(
                                        List.of(
                                                        "Statistical Analysis",
                                                        "Machine Learning",
                                                        "Data Wrangling & EDA",
                                                        "Experimentation & A/B Testing",
                                                        "Data Visualization"),
                                        35, 25)),

                        Map.entry("Data Engineer", new TopicConfig(
                                        List.of(
                                                        "Data Pipelines & ETL",
                                                        "Data Warehousing",
                                                        "Stream Processing",
                                                        "SQL & Query Optimization",
                                                        "Orchestration Tools"),
                                        30, 20)),

                        Map.entry("Product Manager", new TopicConfig(
                                        List.of(
                                                        "Product Strategy & Roadmapping",
                                                        "User Research & Discovery",
                                                        "Stakeholder Management",
                                                        "Data-Driven Decision Making",
                                                        "Go-to-Market Strategy"),
                                        30, 20)),

                        Map.entry("Business Analyst", new TopicConfig(
                                        List.of(
                                                        "Requirements Gathering",
                                                        "Process Modeling",
                                                        "Stakeholder Management",
                                                        "Data Analysis",
                                                        "Documentation"),
                                        30, 20)),

                        Map.entry("Engineering Manager", new TopicConfig(
                                        List.of(
                                                        "People Management & Growth",
                                                        "Technical Leadership",
                                                        "Delivery & Planning",
                                                        "Hiring & Culture",
                                                        "Cross-Functional Communication"),
                                        30, 20)),

                        Map.entry("Tech Lead", new TopicConfig(
                                        List.of(
                                                        "Technical Vision & Architecture",
                                                        "Code Review & Quality",
                                                        "Mentoring & Coaching",
                                                        "Delivery Management",
                                                        "Stakeholder Communication"),
                                        30, 20)),

                        Map.entry("Solutions Architect", new TopicConfig(
                                        List.of(
                                                        "System Design",
                                                        "Cloud Architecture",
                                                        "Integration Patterns",
                                                        "Security",
                                                        "Stakeholder Communication"),
                                        30, 20)),

                        Map.entry("QA Engineer", new TopicConfig(
                                        List.of(
                                                        "Test Planning & Strategy",
                                                        "Test Automation Frameworks",
                                                        "Performance & Load Testing",
                                                        "Bug Reporting & Triage",
                                                        "CI/CD Integration"),
                                        30, 20)),

                        Map.entry("Security Engineer", new TopicConfig(
                                        List.of(
                                                        "Application Security (OWASP)",
                                                        "Network Security",
                                                        "Threat Modeling",
                                                        "Vulnerability Assessment",
                                                        "Compliance & Governance"),
                                        30, 20)));

        public TopicConfig getConfig(String targetRole) {
                return ROLE_CONFIGS.getOrDefault(targetRole, DEFAULT);
        }
}
