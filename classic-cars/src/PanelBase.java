import java.awt.event.WindowEvent;

import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;

public class PanelBase {

    private JFrame parent;
    protected JPanel panel;

    public PanelBase(JFrame parent) {
        this.parent = parent;
        panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
    }

    public void show() {
        parent.setContentPane(panel);
        parent.validate();
        parent.repaint();
    }

    protected void close() {
        parent.dispatchEvent(new WindowEvent(parent, WindowEvent.WINDOW_CLOSING));
    }

    public JPanel getPanel() {
        return panel;
    }
}