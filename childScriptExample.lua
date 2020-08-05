-- This is a threaded script, and is just an example!

function sysCall_threadmain()
    sim.loadModule('relaxed_ik_coppeliasim/simExtRelaxedIK/libsimExtRelaxedIK.so', 'RelaxedIK')
    lfs = require( "lfs" )
    success = lfs.chdir('./relaxed_ik_coppeliasim/relaxed_ik_core')
    
    -- Check if the required plugin is there:
    moduleName=0
    moduleVersion=0
    index=0
    relaxedIKModuleNotFound=true
    while moduleName do
        moduleName,moduleVersion=sim.getModuleName(index)
        if (moduleName=='RelaxedIK') then
            relaxedIKModuleNotFound=false
        end
        index=index+1
    end
    if (relaxedIKModuleNotFound) then
        sim.displayDialog('Error','RelaxedIK plugin was not found.',
            sim.dlgstyle_ok,true,nil,{0.8,0,0,0,0,0},{0.5,0,0,1,1,1})
    else
        sim.setModuleInfo('RelaxedIK', sim.moduleinfo_statusbarverbosity, sim.verbosity_infos)
        jointHandles={-1,-1,-1,-1,-1,-1,-1}
        for i=1,7,1 do
            jointHandles[i]=sim.getObjectHandle('Franka_joint'..i)
        end
        
        -- Set-up some of the RML vectors:
        vel=90  
        accel=40
        jerk=80
        currentVel={0,0,0,0,0,0,0}
        currentAccel={0,0,0,0,0,0,0}
        maxVel={vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180}
        maxAccel={accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180}
        maxJerk={jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180}
        targetVel={0,0,0,0,0,0,0}
        
        pos = {0.015,0.015,0.015}
        quat = {0.0,0.0,0.0,1.0}
        counter = 0
        while counter < 1000 do
            xopt = simRelaxedIK.solve(pos, quat)
            -- targetPos1={90*math.pi/180,90*math.pi/180,135*math.pi/180,-45*math.pi/180,90*math.pi/180,180*math.pi/180,0}
            sim.rmlMoveToJointPositions(jointHandles,-1,currentVel,currentAccel,maxVel,maxAccel,maxJerk,xopt,targetVel)
            counter = counter + 1
        end
    end
end
