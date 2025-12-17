package org.example;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Objects;

public class ResultPanel extends PanelBase implements ActionListener {

    public ResultPanel(JFrame parent, String resultText, boolean prevEnabled) {
        super(parent);

        String[] items = splitResultItems(resultText);
        boolean multi = items.length > 1;

        GroupLayout groupLayout = new GroupLayout(panel);
        panel.setLayout(groupLayout);
        groupLayout.setAutoCreateGaps(true);
        groupLayout.setAutoCreateContainerGaps(true);

        GroupLayout.ParallelGroup parallel = groupLayout.createParallelGroup();
        GroupLayout.SequentialGroup sequential = groupLayout.createSequentialGroup();
        groupLayout.setHorizontalGroup(parallel);
        groupLayout.setVerticalGroup(sequential);

        JLabel title = new JLabel(GUI.fromResource(multi ? "resultTitleMulti" : "resultTitleSingle"));
        parallel.addComponent(title);
        sequential.addComponent(title);

        for (String it : items) {
            JLabel row = new JLabel(it);
            parallel.addComponent(row);
            sequential.addComponent(row);
        }


        JButton prevButton = new JButton(GUI.fromResource("Prev"));
        prevButton.setActionCommand("prev");
        prevButton.addActionListener(this);
        prevButton.setEnabled(prevEnabled);
        parallel.addComponent(prevButton);
        sequential.addComponent(prevButton);

        JButton okButton = new JButton("OK");
        okButton.setActionCommand("ok");
        okButton.addActionListener(this);
        parallel.addComponent(okButton);
        sequential.addComponent(okButton);
    }

    private static String[] splitResultItems(String s) {
        if (s == null) return new String[]{""};
        String trimmed = s.trim();

        if (trimmed.contains("\n")) {
            return trimmed.lines().map(String::trim).filter(x -> !x.isEmpty()).toArray(String[]::new);
        }

        return new String[]{trimmed};
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        String action = e.getActionCommand();
        if (Objects.equals(action, "prev")) {
            GUI.prev();
            return;
        }
        if (Objects.equals(action, "ok")) {
            close();
        }
    }
}
