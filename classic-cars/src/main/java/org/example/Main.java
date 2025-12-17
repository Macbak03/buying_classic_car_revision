package org.example;

import CLIPSJNI.Environment;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.ResourceBundle;

public class Main {

    private static String extractResourceToTempFile(String resource, String suffix) throws Exception {
        try (InputStream in = Main.class.getResourceAsStream(resource)) {
            if (in == null) throw new IllegalStateException("No resource: " + resource);
            Path tmp = Files.createTempFile("clips-", suffix);
            Files.copy(in, tmp, StandardCopyOption.REPLACE_EXISTING);
            tmp.toFile().deleteOnExit();
            return tmp.toAbsolutePath().toString();
        }
    }

    public static void main(String[] args) throws Exception {
        Environment clips = new Environment();

        ResourceBundle resources =
                ResourceBundle.getBundle("ClassicCarsResources", new Locale("pl", "PL"));

        String rulesPath = extractResourceToTempFile("/classiccars.clp", ".clp");
        clips.load(rulesPath);
        clips.reset();

        GUI.startGUI(clips, resources);
        GUI.runEngineAndRefreshUI();
    }
}
