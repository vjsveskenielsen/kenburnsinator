
import java.util.List;
import java.io.FileFilter;
import java.io.FilenameFilter;

import de.looksgood.ani.*;
import codeanticode.syphon.*;
import controlP5.*;
import oscP5.*;
import netP5.*;
import processing.net.*;

OscP5 oscP5;
Server localServer;
String ipAdress;
int port = 9999;

ControlP5 cp5;
float speed = .2;

SyphonServer server;

PVector pos = new PVector(0,0);
PVector tpos = new PVector(0,0);

PGraphics placeholder;
PImage output;
ArrayList<PImage> imgs = new ArrayList();
PGraphics c; //canvas
int cs_x, cs_y; //canvas scale; stores the scale to fit c into window

final FilenameFilter PIC_FILTER = new FilenameFilter() {
  final String[] exts = {
    ".png", ".jpg", ".jpeg", ".gif"
  };

  @ Override boolean accept(final File path, String name) {
    name = name.toLowerCase();
    for (final String ext : exts)  if (name.endsWith(ext))  return true;
    return false;
  }
};

void settings() {
  size(1024/2, 576/2, P3D);
}

void setup() {
  placeholder = createPlaceholder();
  c = createGraphics(1920, 1080, P3D);
  c.imageMode(CENTER);
  float sx = (float)width/(float)c.width;
  float sy = (float)height/(float)c.height;
  cs_x = round(sx*c.width);
  cs_y = round(sy*c.height);
  server = new SyphonServer(this, "kenburnsinator");

  controlSetup();
  updateOSC();
  Ani.init(this);
  Ani.setDefaultEasing(Ani.LINEAR);

}

void draw() {
  background(0);
  c.beginDraw();
  c.background(255,0,0);
  if(imgs.size() > 0) output = imgs.get(imgs.size()-1);
  else output = placeholder;

  float s_x, s_y;
  if (pos.x < .5) s_x = 1.-pos.x;
  else s_x = pos.x;
  if (pos.y < .5) s_y = 1.-pos.y;
  else s_y = pos.y;

  c.image(output,pos.x*c.width,pos.y*c.height, s_x*2.*output.width, s_x*2.*output.height);
  c.endDraw();
  image(c, 0+20,0+20,cs_x-40, cs_y-40);
  server.sendImage(c);

  fill(0, 200);
  noStroke();
  rect(width-140, 0, 120, height);

}

void animate(PVector in) {
  tpos.x = in.x;
  tpos.y = in.y;
  Ani.to(pos, speed, "x", tpos.x);
  Ani.to(pos, speed, "y", tpos.y);
}

PGraphics createPlaceholder() {
  PGraphics p = createGraphics(1920, 1080);
  p.beginDraw();
  p.fill(230);
  p.stroke(255);
  p.strokeWeight(5);
  p.rect(0,0,p.width, p.height);
  p.line(0,0, p.width, p.height);
  p.line(p.width, 0, 0, p.height);
  p.endDraw();
  return p;
}

void oscEvent(OscMessage theOscMessage) {
  String str_in[] = split(theOscMessage.addrPattern(), '/');
  println(str_in);
  if (str_in[1].equals("svesketrigger")) {
    /*
    if (str_in[2].equals("linewidth") && theOscMessage.checkTypetag("f")) {
      float value = theOscMessage.get(0).floatValue();
      float max = cp5.getController("linewidth").getMax();
      cp5.getController("linewidth").setValue(value*max);

    } else if (str_in[2].equals("speed") && theOscMessage.checkTypetag("f")) {
      float value = theOscMessage.get(0).floatValue();
      float max = cp5.getController("speed").getMax();
      cp5.getController("speed").setValue(value*max);
    } else {
      chooseAnimation(str_in[2]);
    }
    */
  }
}

void updateOSC() {
  ipAdress = Server.ip();
  oscP5 = new OscP5(this, port);
  cp5.getController("portValue").setLabel("port: " + port);
}
