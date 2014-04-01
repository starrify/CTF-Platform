# Use database "ctf" #

## Problem example: ##

category shall be (WEB|EXPLOIT|REVERSE|CRYPTO|MISC)

    {
        "basescore" : 20,
        "desc" : "<p>\nAfter opening the robot's front panel...</p>",
        "displayname" : "Failure to Boot",
        "category" : "MISC",
        "grader-type": "file",
        "grader" : "bluescreen.py",
        "hint" : "It might be helpful to Google™ the error.",
        "pid" : "fail",
    }

or 

    {
        "basescore" : 20,
        "desc" : "<p>\nAfter opening the robot's front panel...</p>",
        "displayname" : "Failure to Boot",
        "category" : "MISC",
        "grader-type": "key",
        "key" : "AAA{XXXXXXXXXXXXXXXXXXXXXXXX}",
        "hint" : "It might be helpful to Google™ the error.",
        "pid" : "fail",
    }


## Grader example ##

    # This is bluescreen.py

    def grade(team,key):
        if key.upper().find('FAT') != -1:
            return True, 'Correct'
        else:
            return False, 'Incorrect'   


## News exapmle ##

    { 
        "date" : "2014.03.26 23:47", 
        "header" : "开放注册", 
        "articlehtml" : "安恒杯浙江大学第一届AAA信息安全技术挑战赛ACTF开放注册咯:)" 
    }


