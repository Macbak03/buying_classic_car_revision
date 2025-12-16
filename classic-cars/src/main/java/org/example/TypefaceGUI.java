package org.example;

import CLIPSJNI.Environment;
import CLIPSJNI.PrimitiveValue;

import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

public class TypefaceGUI {

    private static JFrame frame;
    private static Environment clips;
    private static ResourceBundle resources;

    public static void startGUI(Environment env, ResourceBundle rb) {
        frame = new JFrame("Buying Classic Car Revision");
        clips = env;
        resources = rb;

        SwingUtilities.invokeLater(() -> {
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(900, 500);
            frame.setResizable(false);
            frame.addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent we) { }
            });

            new StartPanel(frame, "…").show();

            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        });
    }

    public static JFrame getFrame() { return frame; }
    public static Environment getClips() { return clips; }

    public static String tr(String key) {
        if (key == null) return "";
        try {
            return resources.getString(key);
        } catch (MissingResourceException e) {
            //e.printStackTrace();
            return key;
        }
    }

    public static void runEngineAndRefreshUI() {
        new Thread(() -> {
            clips.run();
            SwingUtilities.invokeLater(() -> {
                try {
                    refreshUIFromClips();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
        }).start();
    }

    public static void next(String selectedAnswerKeyOrNull) {
        try {
            String currentID = getCurrentUIStateId();
            if (selectedAnswerKeyOrNull == null || selectedAnswerKeyOrNull.isBlank()) {
                clips.assertString("(next " + currentID + ")");
            } else {
                clips.assertString("(next " + currentID + " " + selectedAnswerKeyOrNull + ")");
            }
            runEngineAndRefreshUI();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void prev() {
        try {
            String currentID = getCurrentUIStateId();
            clips.assertString("(prev " + currentID + ")");
            runEngineAndRefreshUI();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static boolean canPrev() {
        try {
            PrimitiveValue sl = clips.eval("(find-all-facts ((?f state-list)) TRUE)");
            if (sl.size() == 0) return false;
            PrimitiveValue seq = sl.get(0).getFactSlot("sequence");
            return seq != null && seq.size() >= 2;
        } catch (Exception e) {
            return false;
        }
    }

    private static String getCurrentUIStateId() throws Exception {
        PrimitiveValue sl = clips.eval("(find-all-facts ((?f state-list)) TRUE)");
        if (sl.size() == 0) throw new IllegalStateException("Brak state-list w CLIPS");
        return sl.get(0).getFactSlot("current").toString();
    }

    private static PrimitiveValue getCurrentUIState() throws Exception {
        String currentID = getCurrentUIStateId();
        String evalStr = "(find-all-facts ((?f UI-state)) (eq ?f:id " + currentID + "))";
        PrimitiveValue ui = clips.eval(evalStr);
        if (ui.size() == 0) throw new IllegalStateException("Brak UI-state o id=" + currentID);
        return ui.get(0);
    }

    private static void refreshUIFromClips() throws Exception {
        PrimitiveValue ui = getCurrentUIState();

        String state = ui.getFactSlot("state").toString();
        String displayKey = ui.getFactSlot("display").symbolValue();

        boolean prevEnabled = canPrev();

        if ("initial".equals(state)) {
            new StartPanel(frame, tr(displayKey)).show();
            return;
        }

        if ("final".equals(state)) {
            new ResultPanel(frame, tr(displayKey), prevEnabled).show();
            return;
        }

        PrimitiveValue answersPV = ui.getFactSlot("valid-answers");
        String defaultKey = ui.getFactSlot("response").toString();

        String[] answerKeys = new String[answersPV.size()];
        for (int i = 0; i < answersPV.size(); i++) {
            answerKeys[i] = answersPV.get(i).toString();
        }

        new QuestionPanel(frame, tr(displayKey), answerKeys, defaultKey, prevEnabled).show();    }
}
