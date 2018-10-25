/*
void controlSetup() {
  cp5 = new ControlP5(this);
  int xoff = width-160, yoff = 20;
  int s_width = 100;
  int s_height = 20;

  cp5.addSlider("speed")
    .setPosition(xoff, yoff)
    .setSize(s_width, s_height)
    .setRange(0.2, 3)
    .setValue(.2)
    .setLabel("speed")
    ;
    cp5.getController("speed").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    cp5.getController("speed").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  yoff += 50;

  cp5.addBang("random")
    .setPosition(xoff, yoff)
    .setSize(15, 20)
    .setTriggerEvent(Bang.RELEASE)
    ;

}



void speed(float value) {
  speed = value;
}

public void random() {
  animate(new PVector(random(0,1)*c.width, random(0,1)*c.height, random(1, 2)));
}
*/
