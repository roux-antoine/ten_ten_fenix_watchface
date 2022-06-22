import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ten_ten_fenix_watchfaceView extends WatchUi.WatchFace {

    var showSeconds = 0;
    var radiusHour = 79;
    var radiusMinute = 113;
    var radiusSecond = 52;
    var middleX = 130;
    var middleY = 130;
    var hourHandAngle = 210;
    var minuteHandAngle = 330;
    var secondHandAngle = 90;
    var lengthHour = 40;
    var lengthMinute = 65;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var date = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var tipHourX = middleX + Math.cos(hourHandAngle * Math.PI / 180) * lengthHour;
        var tipHourY = middleY + Math.sin(hourHandAngle * Math.PI / 180) * lengthHour;
        var tipMinuteX = middleX + Math.cos(minuteHandAngle * Math.PI / 180) * lengthMinute;
        var tipMinuteY = middleY + Math.sin(minuteHandAngle * Math.PI / 180) * lengthMinute;

        // clear the screen
        dc.setColor(Toybox.Graphics.COLOR_TRANSPARENT, Toybox.Graphics.COLOR_BLACK );
        dc.clear();

        dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawLine(middleX, middleY, tipHourX, tipHourY);
        dc.drawLine(middleX, middleY, tipMinuteX, tipMinuteY);

        dc.setPenWidth(1);
        dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(middleX, middleY, radiusHour);
        dc.drawCircle(middleX, middleY, radiusMinute);

        var hourCounter = 0;
        var hourFont;
        for (var i = date.hour; i < date.hour+12; i++) {
            if (i == date.hour) {
                dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_BLACK);
                hourFont = Toybox.Graphics.FONT_MEDIUM;
            }
            else {
                dc.setColor(Toybox.Graphics.COLOR_LT_GRAY, Toybox.Graphics.COLOR_BLACK);
                hourFont = Toybox.Graphics.FONT_TINY;

            }
            var currentTextAngle = (hourHandAngle + 30 * hourCounter) * Math.PI / 180;
            var posHourX = middleX + Math.cos(currentTextAngle) * radiusHour;
            var posHourY = middleY + Math.sin(currentTextAngle) * radiusHour;
            var hourText = i%12;
            if (hourText == 0) {
                hourText = 12;
            }
            dc.drawText(posHourX, posHourY-16, hourFont, hourText, Toybox.Graphics.TEXT_JUSTIFY_CENTER);
            hourCounter += 1;
        }

        var minuteCounter = 0;
        var minuteFont;
        for (var i = date.min; i < date.min+60; i+=5) {
            if (i == date.min) {
                dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_BLACK);
                minuteFont = Toybox.Graphics.FONT_MEDIUM;
            }
            else {
                dc.setColor(Toybox.Graphics.COLOR_LT_GRAY, Toybox.Graphics.COLOR_BLACK);
                minuteFont = Toybox.Graphics.FONT_TINY;
            }
            var currentTextAngle = (minuteHandAngle + 30 * minuteCounter) * Math.PI / 180;
            var posMinuteX = middleX + Math.cos(currentTextAngle) * radiusMinute;
            var posMinuteY = middleY + Math.sin(currentTextAngle) * radiusMinute;
            var minuteText = i%60;
            if (minuteText == 0) {
                minuteText = 60;
            }
            dc.drawText(posMinuteX, posMinuteY-16, minuteFont, minuteText, Toybox.Graphics.TEXT_JUSTIFY_CENTER);
            minuteCounter += 1;
        }

        if (showSeconds == 1) {
            var secondCounter = -3;
            var secondFont;
            for (var i = date.sec-3; i < date.sec+4; i++) {
                if (i == date.sec) {
                    dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_BLACK);
                    secondFont = Toybox.Graphics.FONT_XTINY;
                }
                else if (secondCounter == -3 || secondCounter == 3) {
                    dc.setColor(Toybox.Graphics.COLOR_DK_GRAY, Toybox.Graphics.COLOR_BLACK);
                    secondFont = Toybox.Graphics.FONT_XTINY;
                }
                else {
                    dc.setColor(Toybox.Graphics.COLOR_LT_GRAY, Toybox.Graphics.COLOR_BLACK);
                    secondFont = Toybox.Graphics.FONT_XTINY;
                }
                var currentTextAngle = (secondHandAngle + 26 * secondCounter) * Math.PI / 180;
                var posSecondX = middleX + Math.cos(currentTextAngle) * radiusSecond;
                var posSecondY = middleY + Math.sin(currentTextAngle) * radiusSecond;
                var secondText = (i+60)%60;
                if (secondText == 0) {
                    secondText = 60;
                }
                dc.drawText(posSecondX, posSecondY-8, secondFont, secondText, Toybox.Graphics.TEXT_JUSTIFY_CENTER);
                secondCounter += 1;
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        showSeconds = 1;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        showSeconds = 0;
    }

}
