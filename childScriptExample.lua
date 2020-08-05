-- This is a threaded script, and is just an example!

function sysCall_threadmain()
    sim.loadModule('relaxed_ik_coppeliasim/simExtRelaxedIK/libsimExtRelaxedIK.so', 'RelaxedIK')
    
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
        sim.displayDialog('Error','The RelaxedIK plugin was not found.',
            sim.dlgstyle_ok,true,nil,{0.8,0,0,0,0,0},{0.5,0,0,1,1,1})
    else
        lfs = require( "lfs" )
        lfs.chdir('./relaxed_ik_coppeliasim/relaxed_ik_core')
        sim.setModuleInfo('RelaxedIK', sim.moduleinfo_statusbarverbosity, sim.verbosity_infos)
        
        pos = {0.015,0.015,0.015}
        quat = {0.0,0.0,0.0,1.0}

        while true do
            xopt = simRelaxedIK.solve(pos, quat)
        end
    end
end
