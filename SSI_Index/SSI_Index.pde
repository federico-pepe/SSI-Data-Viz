// Data Variables
Table data;
float[] educationValues, gdpValues;
float eduMin, eduMax, gdpMin, gdpMax;

// GUI Defaults;
int margin = 100;
boolean showLabel = false;
float scaleFactor = 1, translateX = 0, translateY = 0;

void setup() {
  size(800, 700);
  pixelDensity(2);
  getData();
}

void draw() {
  // DEBUGGING FRAMERATE
  surface.setTitle(int(frameRate) + " fps / " + frameCount + " frames");
  // DEFAULTS
  background(255);
  fill(127);
  text("Press 'R' to reset zoom/position, 'L' to show labels", margin, margin/2);
  // DRAW THE DATAVIZ
  if (scaleFactor < 1 || translateX > 0) {
    scaleFactor = 1;
    translateX = 0;
    translateY = 0;
  }
  pushMatrix();
  translate(translateX, translateY);
  drawGUI();
  drawData();
  popMatrix();
}

void getData() {
  /////////////// LOADING DATA ///////////////
  // 
  // CSV HEADER:
  // [0]REGION | [1]UN REGION | [2]COUNTRY | [3]2006 %Edu | [4]2006 GDP
  //
  ///////////////////////////////////////////
  data = loadTable("data.csv", "header");

  educationValues = new float[data.getRowCount()];
  gdpValues = new float[data.getRowCount()];

  for (int i = 0; i < data.getRowCount(); i++) {
    educationValues[i] = data.getFloat(i, 3);
    gdpValues[i] = data.getFloat(i, 4);
  }

  eduMin = min(educationValues);
  eduMax = max(educationValues);
  gdpMin = min(gdpValues);
  gdpMax = max(gdpValues);
}

void drawGUI() {
  /////////////// DRAWING GUI ////////////////
  ////////////////////////////////////////////
  fill(127);
  stroke(200);

  // X, Y AXIS
  line(margin, margin, margin, height-margin);
  line(margin, height-margin, width-margin, height-margin);

  // REFERENCE LINES EDUCATION
  for (int i = round(eduMin); i <= round(eduMax); i++) {
    if (i % 5 == 0) {
      stroke(200, 60);
      float yPos = map(i, eduMin, eduMax, height - margin - 10, margin+10);
      textAlign(CENTER);
      text(i + " %", margin - 5 + (translateX*-1), yPos + 4);
      line(margin, yPos, (width - margin) + (translateX*-1), yPos);
    }
  }
  // REFERENCE LINES GDP
  for (int i = round(gdpMin); i <= round(gdpMax); i++) {
    int reference = 10000;
    reference /= round(scaleFactor);
    if (i % reference == 0) {
      stroke(200, 60);
      float xPos = map(i, gdpMin, gdpMax, margin+10, (width - margin -10)*scaleFactor);
      //if (xPos <= width-margin) {
        textAlign(LEFT);
        text(nfc(i), xPos - 25, height - margin + 20);
        line(xPos, margin, xPos, height - margin);
      //}
    }
  }

  // LABELS
  textAlign(CENTER, CENTER);

  pushMatrix();
  translate(margin/3, margin);
  rotate(-HALF_PI);
  text("Education Enrollment Rate", 0, 0);
  popMatrix();

  text("GDP in $US", width-margin, height - margin + (margin/2));
}

void drawData() {
  /////////////// DRAWING DATA ///////////////
  ////////////////////////////////////////////
  color[] palette = {
    #EAC435, // AFRICA
    #345995, // AMERICA
    #E40066, // ASIA
    #03CEA4, // EUROPE
    #FA7921, // OCEANIA
  };
  noFill();
  stroke(0);
  textAlign(LEFT);
  for (int i = 0; i < educationValues.length; i++) {
    float xPos = map(gdpValues[i], gdpMin, gdpMax, margin+10, (width - margin -10)*scaleFactor);
    float yPos = map(educationValues[i], eduMin, eduMax, height - margin - 10, margin+10);
    //if (xPos <= width-margin) {
      noStroke();
      switch(data.getString(i, 0)) {
      case "Africa":
        fill(palette[0]);
        break;
      case "America":
        fill(palette[1]);
        break;
      case "Asia":
        fill(palette[2]);
        break;
      case "Europe":
        fill(palette[3]);
        break;
      case "Oceania":
        fill(palette[4]);
        break;
      }

      ellipse(xPos, yPos, 10, 10);
      if (showLabel) {
        text(data.getString(i, 2), xPos + 10, yPos + 3);
      }
    //}
  }
}

void keyPressed() {
  if (key == 'r') {
    scaleFactor = 1;
    translateX = 0;
    translateY = 0;
  }
  if (key == 'l') {
    showLabel = !showLabel;
  }
}

void mouseWheel(MouseEvent e) {
  scaleFactor += float(e.getCount())*0.1;
 // translateX = translateX - float(e.getCount())*mouseX*0.1;
  //translateY = translateY - float(e.getCount())*mouseY*0.1;
}

void mouseDragged(MouseEvent e) {
  translateX += mouseX - pmouseX;
  println(translateX);
 // translateY += mouseY - pmouseY;
}