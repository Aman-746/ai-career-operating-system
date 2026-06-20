package com.aman.careeros.service;

import com.aman.careeros.entity.ExperienceLevel;
import com.aman.careeros.entity.Resume;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * ResumeAnalysisService - Extracts text from uploaded resumes and derives
 * skill signals using keyword matching against a curated taxonomy.
 *
 * PDF extraction uses Apache PDFBox; DOCX extraction uses the built-in JDK
 * ZIP + XML APIs (no extra dependency). Legacy DOC binary files return an
 * empty skill list.
 *
 * analyzeAndPopulate() is called synchronously inside the upload request so
 * the Resume entity is fully populated before it's persisted. If extraction
 * fails for any reason, the error is logged and analysis fields are left
 * as empty/null — the upload itself still succeeds.
 */
@Service
@Slf4j
public class ResumeAnalysisService {

    private static final String DOCX_CONTENT_TYPE =
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    private static final String DOCX_WORD_NAMESPACE =
            "http://schemas.openxmlformats.org/wordprocessingml/2006/main";

    private static final Set<String> SKILL_TAXONOMY = Set.of(
            // Programming Languages
            "Java", "Python", "JavaScript", "TypeScript", "Go", "Rust", "C++", "C#",
            "Swift", "Kotlin", "Scala", "Ruby", "PHP",
            // Frontend
            "React", "Vue", "Angular", "Next.js", "HTML", "CSS", "Tailwind", "GraphQL",
            "REST", "Redux",
            // Backend
            "Spring Boot", "Django", "Flask", "FastAPI", "Node.js", "Express", "Rails", "gRPC",
            // Databases
            "SQL", "PostgreSQL", "MySQL", "MongoDB", "Redis", "Cassandra", "DynamoDB", "Elasticsearch",
            // Cloud & DevOps
            "AWS", "GCP", "Azure", "Docker", "Kubernetes", "Terraform", "CI/CD", "Linux", "Ansible",
            // Data & ML
            "TensorFlow", "PyTorch", "scikit-learn", "Pandas", "NumPy", "Spark", "Kafka",
            "Airflow", "MLflow", "dbt",
            // Mobile
            "SwiftUI", "UIKit", "Jetpack Compose", "Android",
            // Architecture & Practices
            "Microservices", "System Design", "API Design", "Git", "Agile", "Scrum", "TDD", "DevOps"
    );

    /**
     * Reads the stored resume file, extracts text, and populates the analysis
     * fields on the given Resume entity. yearsOfExperience comes from the
     * OnboardingProfile so we don't have to re-derive it from the resume text.
     */
    public void analyzeAndPopulate(Resume resume, int yearsOfExperience) {
        String text = extractText(resume.getStoragePath(), resume.getContentType());
        resume.setDetectedSkills(detectSkills(text));
        resume.setExperienceLevel(ExperienceLevel.fromYearsOfExperience(yearsOfExperience));
    }

    private String extractText(String storagePath, String contentType) {
        try {
            if ("application/pdf".equals(contentType)) {
                return extractFromPdf(storagePath);
            } else if (DOCX_CONTENT_TYPE.equals(contentType)) {
                return extractFromDocx(storagePath);
            }
            // Legacy DOC binary format: no extraction in V1
            return "";
        } catch (Exception e) {
            log.warn("Resume text extraction failed for {}: {}", storagePath, e.getMessage());
            return "";
        }
    }

    private String extractFromPdf(String storagePath) throws IOException {
        try (PDDocument document = Loader.loadPDF(new File(storagePath))) {
            return new PDFTextStripper().getText(document);
        }
    }

    private String extractFromDocx(String storagePath)
            throws IOException, ParserConfigurationException, SAXException {
        try (ZipInputStream zip = new ZipInputStream(new FileInputStream(storagePath))) {
            ZipEntry entry;
            while ((entry = zip.getNextEntry()) != null) {
                if ("word/document.xml".equals(entry.getName())) {
                    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                    factory.setNamespaceAware(true);
                    // Prevent XXE on user-supplied XML content
                    factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
                    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
                    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);

                    DocumentBuilder builder = factory.newDocumentBuilder();
                    Document doc = builder.parse(zip);

                    NodeList textNodes = doc.getElementsByTagNameNS(DOCX_WORD_NAMESPACE, "t");
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < textNodes.getLength(); i++) {
                        sb.append(textNodes.item(i).getTextContent()).append(" ");
                    }
                    return sb.toString();
                }
            }
        }
        return "";
    }

    private List<String> detectSkills(String text) {
        if (text.isBlank()) {
            return Collections.emptyList();
        }
        String lower = text.toLowerCase();
        return SKILL_TAXONOMY.stream()
                .filter(skill -> lower.contains(skill.toLowerCase()))
                .sorted()
                .limit(8)
                .toList();
    }

}
