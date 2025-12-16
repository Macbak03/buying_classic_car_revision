package org.example;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Objects;

public class QuestionPanel extends PanelBase implements ActionListener {

    private final JButton nextButton;
    private final JButton prevButton;
    private String selectedKey;

    public QuestionPanel(JFrame parent, String questionText, String[] answerKeys, String defaultKey, boolean prevEnabled) {
        super(parent);

        GroupLayout groupLayout = new GroupLayout(panel);
        panel.setLayout(groupLayout);
        groupLayout.setAutoCreateGaps(true);
        groupLayout.setAutoCreateContainerGaps(true);

        GroupLayout.ParallelGroup parallel = groupLayout.createParallelGroup();
        GroupLayout.SequentialGroup sequential = groupLayout.createSequentialGroup();
        groupLayout.setHorizontalGroup(parallel);
        groupLayout.setVerticalGroup(sequential);

        JLabel questionLabel = new JLabel(questionText);
        parallel.addComponent(questionLabel);
        sequential.addComponent(questionLabel);

        ButtonGroup buttons = new ButtonGroup();

        for (String key : answerKeys) {
            String label = TypefaceGUI.tr(key);
            JRadioButton button = new JRadioButton(label);
            button.setActionCommand(key);
            button.addActionListener(this);

            if (key.equals(defaultKey)) {
                button.setSelected(true);
                selectedKey = key;
            }

            buttons.add(button);
            parallel.addComponent(button);
            sequential.addComponent(button);
        }

        nextButton = new JButton("Next");
        nextButton.setActionCommand("_next_");
        nextButton.addActionListener(this);

        nextButton.setEnabled(selectedKey != null);
        parallel.addComponent(nextButton);
        sequential.addComponent(nextButton);

        prevButton = new JButton(TypefaceGUI.tr("Prev"));
        prevButton.setActionCommand("_prev_");
        prevButton.addActionListener(this);
        prevButton.setEnabled(prevEnabled);

        parallel.addComponent(prevButton);
        sequential.addComponent(prevButton);
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        String action = event.getActionCommand();

        if (Objects.equals(action, "_next_")) {
            TypefaceGUI.next(selectedKey);
        } else {
            selectedKey = action;
            nextButton.setEnabled(true);
        }
        if (Objects.equals(action, "_prev_")) {
            TypefaceGUI.prev();
        }
    }
}
