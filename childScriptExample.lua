-- This is a threaded script, and is just an example!

function sysCall_threadmain()
    relaxedIKModuleLoaded = sim.loadModule('relaxed_ik_coppeliasim/simExtRelaxedIK/libsimExtRelaxedIK.so', 'RelaxedIK')
    
    if (relaxedIKModuleLoaded) then
        lfs = require( "lfs" )
        lfs.chdir('./relaxed_ik_coppeliasim/relaxed_ik_core')
        sim.setModuleInfo('RelaxedIK', sim.moduleinfo_statusbarverbosity, sim.verbosity_infos)
        
        pos = {0.015,0.015,0.015}
        quat = {0.0,0.0,0.0,1.0}

        while true do
            xopt = simRelaxedIK.solve(pos, quat)
        end
    else
        sim.displayDialog('Error','The RelaxedIK plugin was not found.',
            sim.dlgstyle_ok,true,nil,{0.8,0,0,0,0,0},{0.5,0,0,1,1,1})
    end
end