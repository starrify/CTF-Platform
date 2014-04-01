# Use database "ctf" #

## Problem example: ##

    {
        "autogen" : false,
        # edit the following field:
        "basescore" : 20,
        # edit the following field:
        "desc" : "<p>\nAfter opening the robot's front panel...</p>",
        # edit the following field:
        "displayname" : "Failure to Boot",
        # edit the following field: (WEB|EXPLOIT|REVERSE|CRYPTO|MISC)
        "category" : "MISC",
        # edit the following field:
        "grader" : "bluescreen.py",
        # edit the following field:
        "hint" : "It might be helpful to Google™ the error.",
        # edit the following field:
        "pid" : "fail",
        "threshold" : 0,
        "weightmap" : {}
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
        # edit the following field:
        "date" : "2014.03.26 23:47", 
        # edit the following field:
        "header" : "开放注册", 
        # edit the following field:
        "articlehtml" : "安恒杯浙江大学第一届AAA信息安全技术挑战赛ACTF开放注册咯:)" 
    }


