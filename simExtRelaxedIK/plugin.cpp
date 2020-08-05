// Copyright 2016 Coppelia Robotics GmbH. All rights reserved. 
// marc@coppeliarobotics.com
// www.coppeliarobotics.com
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// -------------------------------------------------------------------
// Authors:
// Federico Ferri <federico.ferri.it at gmail dot com>
// -------------------------------------------------------------------

#include "plugin.h"
#include "simPlusPlus/Plugin.h"
#include "stubs.h"

#include <sstream>

class Plugin : public sim::Plugin
{
public:
    void onStart()
    {
        if(!registerScriptStuff())
            throw std::runtime_error("script stuff initialization failed");

        setExtVersion("Relaxed IK");
        setBuildDate(BUILD_DATE);
    }

    void solve(solve_in *in, solve_out *out)
    {
        std::vector<double> pos = in->position;
        std::vector<double> quat = in->rotation;

        Opt x = run_coppeliasim(pos.data(), (int) pos.size(), quat.data(), (int) quat.size());
        std::vector<double> sol(x.length, 0.0);
        for (int i = 0; i < x.length; i++) {
            sol[i] = x.data[i];
        }
        out->solution = sol;

        log(sim_verbosity_infos, std::to_string(x.length));

        std::ostringstream sol_str; 
        if (!out->solution.empty()) 
        { 
            sol_str << "RelaxedIK: [";

            // Convert all but the last element to avoid a trailing "," 
            std::copy(out->solution.begin(), out->solution.end() - 1, 
                std::ostream_iterator<double>(sol_str, ", ")); 
        
            // Now add the last element with no delimiter 
            sol_str << out->solution.back() << "]";
        } 

        // log a message
        log(sim_verbosity_infos, sol_str.str());
    }
};

SIM_PLUGIN("RelaxedIK", 1, Plugin)
#include "stubsPlusPlus.cpp"
