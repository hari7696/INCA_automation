import java.awt.Robot;
import java.awt.event.KeyEvent;
robot = Robot;
pause(5)

for i = 1:2000
    arrow_stroke(1, robot);
    space_stroke(robot);
end

function arrow_stroke(n, robot)
import java.awt.event.KeyEvent;
for i=1:n
    robot.keyPress(KeyEvent.VK_DOWN);
    robot.keyRelease(KeyEvent.VK_DOWN);
end
robot.delay(10)
end

function space_stroke(robot)
import java.awt.event.KeyEvent;
robot.keyPress(KeyEvent.VK_SPACE);
robot.delay(10);
robot.keyRelease(KeyEvent.VK_SPACE);
robot.delay(10);
pause(0.7)
end