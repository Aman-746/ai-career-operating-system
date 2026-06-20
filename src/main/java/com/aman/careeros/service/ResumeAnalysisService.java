package com.aman.careeros.service;

import com.aman.careeros.entity.ExperienceLevel;
import com.aman.careeros.entity.Resume;
import com.aman.careeros.resume.SkillExtractor;
import com.aman.careeros.resume.SkillMatch;
import lombok.RequiredArgsConstructor;
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
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

@Service
@RequiredArgsConstructor
@Slf4j
public class ResumeAnalysisService {

    private static final String DOCX_CONTENT_TYPE =
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    private static final String DOCX_WORD_NAMESPACE =
            "http://schemas.openxmlformats.org/wordprocessingml/2006/main";

    private final SkillExtractor skillExtractor;

    public void analyzeAndPopulate(Resume resume, int yearsOfExperience) {
        String text = extractText(resume.getStoragePath(), resume.getContentType());
        List<SkillMatch> matches = skillExtractor.extract(text);
        resume.setDetectedSkills(matches.stream().map(SkillMatch::canonical).toList());
        resume.setExperienceLevel(ExperienceLevel.fromYearsOfExperience(yearsOfExperience));
    }

    private String extractText(String storagePath, String contentType) {
        try {
            if ("application/pdf".equals(contentType)) {
                return extractFromPdf(storagePath);
            } else if (DOCX_CONTENT_TYPE.equals(contentType)) {
                return extractFromDocx(storagePath);
            }
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
}
