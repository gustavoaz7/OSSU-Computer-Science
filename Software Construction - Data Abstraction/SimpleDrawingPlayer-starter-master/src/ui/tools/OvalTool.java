package ui.tools;

import model.Oval;
import ui.DrawingEditor;

import javax.swing.*;
import java.awt.event.MouseEvent;

public class OvalTool extends ShapeTool {

    public OvalTool(DrawingEditor editor, JComponent parent){
        super(editor, parent);
    }

    protected void makeShape(MouseEvent e) {
        shape = new Oval(e.getPoint(), editor.getMidiSynth());
    }

    protected String getLabel() {
        return "Oval";
    }
}