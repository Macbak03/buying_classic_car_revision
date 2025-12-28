import CLIPSJNI.Environment;


import java.util.Locale;
import java.util.ResourceBundle;

public class Main {


    public static void main(String[] args) throws Exception {
        Environment clips = new Environment();
        ResourceBundle resources =
                ResourceBundle.getBundle("resources.ClassicCarsResources", Locale.getDefault());

        clips.load("classiccars.clp");
        clips.reset();
        
        GUI.startGUI(clips, resources);
        GUI.runEngineAndRefreshUI();
    }
}
