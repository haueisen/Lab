public class IMGAnimation {
  
  private int _maxFrames;
  private int _numFrames;
  private int _delay;
  private int _counter;
  private int _current;
  private String[] _frames;
  
  //private PImage[] _frames;
  
  public boolean loopAnim = true;
  public boolean autoPlay = true;
  
  public IMGAnimation(int maxframes, int delay) {
    this._maxFrames = maxframes;
    this._numFrames = 0;
    this._counter = 0;
    this._current = 0;
    this.setDelay(delay);
    this._frames = new String[maxframes];
  }
  
  public IMGAnimation(String path, int numframes, int delay) {
    this._maxFrames = numframes;
    this._numFrames = 0;
    this._counter = 0;
    this._current = 0;
    this.setDelay(delay);
    this._frames = new String[numframes];
    this.loadFrames(path, numframes);
  }
  
  public IMGAnimation(String path, int numframes, int delay, boolean loopme) {
    this._maxFrames = numframes;
    this._numFrames = 0;
    this._counter = 0;
    this._current = 0;
    this.setDelay(delay);
    this._frames = new String[numframes];
    this.loadFrames(path, numframes);
    this.loopAnim = loopme;
  }
  
  public IMGAnimation(String path, int numframes, int delay, boolean loopme, boolean autoplay) {
    this._maxFrames = numframes;
    this._numFrames = 0;
    this._counter = 0;
    this._current = 0;
    this.setDelay(delay);
    this._frames = new String[numframes];
    this.loadFrames(path, numframes);
    this.loopAnim = loopme;
    this.autoPlay = autoplay;
  }
  
  public void setDelay(int delay) {
    if (delay > 0) {
      this._delay = delay;
    } else {
      this._delay = 1;
    }
  }
  
 public void setCurrentFrame(int frame) {    
   this._current = frame;
   this._counter = frame;      
 }
  
  /*public boolean setCurrentFrame(int frame) {
    if (frame < this._numFrames) {
      this._current = frame;
      this._counter = 0;
      return (true);
    } else {
      return (false);
    }
  }*/
  
  public PImage getFrame(PImage image) {
    if (this._numFrames == 0) {
      return (null);
    } else if (!this.autoPlay) {
      return (loadImage(this._frames[this._current]));
    } else if (!this.loopAnim && (this._current >= (this._numFrames -1))) {
      this._current = this._numFrames - 1;
      return (loadImage(this._frames[this._current]));
    } else {
      this._counter++;
      if (this._counter >= this._delay) {
        this._counter = 0;
        this._current++;
        if (this._current >= this._numFrames) {
          if (this.loopAnim) {
            this._current = 0;
          } else {
            this._current = this._numFrames - 1;
          }
        }
      }
      background(image);
      return (loadImage(this._frames[this._current]));
    }
  }
  
  public boolean nextFrame() {
    if (this._numFrames > 0) {
      this._current++;
      if (this._current >= this._numFrames) {
        if (this.loopAnim) {
          this._current = 0;
        } else {
          this._current = this._numFrames - 1;
        }
      }
      return (true);
    } else {
      return (false);
    }
  }
  
  public boolean addFrame(String framepath) {
    if (this._numFrames >= this._maxFrames) {
      return (false);
    } else {
      this._frames[this._numFrames] = framepath;
      this._numFrames++;
      return (true);
    }
  }
  
  public boolean setFrame(int framenum, String framepath) {
    if (framenum < this._numFrames) {
      this._frames[framenum] = framepath;
      return (true);
    } else {
      return (false);
    }
  }
  
  public boolean loadFrames(String path, int total) {
    if ((total > this._maxFrames) || (total <= 0)) {
      return (false);
    } else {
      this._numFrames = 0;
      for (int i=0; i<this._maxFrames; i++) {
        if (i < total) {
          this._frames[i] = path.replace("#", ""+i);
          this._numFrames++;
        } else {
          this._frames[i] = null;
        }
      }
      return (true);
    }
    
  }
  
  public int currentFrame() {
    return (this._current);
  }
  
  public String toString() {
    return ("IMGAnimation object -> maximum frames: " + this._maxFrames + "; current frames: " + this._numFrames + "; looping: " + this.loopAnim + "; delay: " + this._delay);
  }
  
}
