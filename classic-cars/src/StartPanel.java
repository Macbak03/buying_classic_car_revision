import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Objects;

public class StartPanel extends PanelBase implements ActionListener {

    public StartPanel(JFrame parent, String welcomeText) {
        super(parent);

        panel.add(new JLabel(welcomeText));

        JButton startButton = new JButton("Start");
        startButton.setActionCommand("start");
        startButton.addActionListener(this);
        panel.add(startButton);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (Objects.equals(e.getActionCommand(), "start")) {
            GUI.next(null);
        }
    }
}