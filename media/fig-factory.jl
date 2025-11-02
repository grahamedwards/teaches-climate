### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ c6ac4680-7df6-11f0-1c46-a372ada2784f
let 
	import Pkg; Pkg.activate()
	using Downloads, DelimitedFiles, CairoMakie
end

# ╔═╡ 39aae521-e376-487b-bc06-6862558361fe
dark_mode() = Theme( fontsize = 20,

    backgroundcolor=:transparent, labelcolor=:white,
    

    Axis =(backgroundcolor=:transparent, 

        spinewidth=2.,ytickwidth=2., xtickwidth=2.,
        
        bottomspinecolor=:white,topspinecolor=:white,leftspinecolor=:white,rightspinecolor=:white,
        

        xgridcolor=(:white,0.2),ygridcolor=(:white,0.2),

        xtickcolor=:white,ytickcolor=:white, 
        yticklabelcolor=:white,xticklabelcolor=:white,
        
        xlabelcolor=:white,ylabelcolor=:white,titlecolor=:white),

    Legend = (
        labelcolor=:white,
        backgroundcolor=:transparent,
        framecolor=:white),
        )

# ╔═╡ 1e65e687-75c8-43ce-811b-a88c102f78d6
z, T, P, ρ = [-1.0, 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 13.0, 15.0, 17.0, 20.0, 25.0, 30.0, 32.0, 35.0, 40.0, 45.0, 47.0, 50.0, 51.0, 60.0, 70.0, 71.0, 80.0, 84.9, 89.7, 100.4, 105.0, 110.0], [21.5, 15.0, 8.5, 2.0, -4.5, -11.0, -17.5, -24.0, -30.5, -37.0, -43.5, -50.0, -56.5, -56.5, -56.5, -56.5, -56.5, -51.5, -46.5, -44.5, -36.1, -22.1, -8.1, -2.5, -2.5, -2.5, -27.7, -55.7, -58.5, -76.5, -86.3, -86.3, -73.6, -55.5, -9.2], [113.92, 101.325, 89.874, 79.495, 70.108, 61.64, 54.019, 47.181, 41.06, 35.599, 30.742, 26.436, 22.632, 16.51, 12.044, 8.787, 5.475, 2.511, 1.172, 0.868, 0.559, 0.278, 0.143, 0.111, 0.076, 0.067, 0.02031, 0.00463, 0.00396, 0.00089, 0.00037, 0.00015, 2.0e-5, 1.0e-5, 1.0e-5], [1.347, 1.225, 1.1116, 1.0065, 0.9091, 0.8191, 0.7361, 0.6597, 0.5895, 0.5252, 0.4664, 0.4127, 0.3639, 0.2655, 0.1937, 0.1423, 0.088, 0.0395, 0.018, 0.0132, 0.0082, 0.0039, 0.0019, 0.0014, 0.001, 0.00086, 0.000288, 7.4e-5, 6.4e-5, 1.5e-5, 7.0e-6, 3.0e-6, 5.0e-7, 2.0e-7, 1.0e-7]

# ╔═╡ c6414566-5cf0-48ca-ac65-8559ce6c01e0


# ╔═╡ c2f7b905-6b61-43ee-9830-636e8abc885b
let

	H = 287.053 * (273.15)/9.8
	shared = (; xlabelsize=24, xticklabelsize=18, yminorgridvisible=true, xminorgridvisible=true, yticks=0:20:100, ylabelsize=24, yticklabelsize=18, yticksmirrored=true, yminorticks=IntervalsBetween(2),titlesize=18)
	
	f=Figure(size=(800,300))
	
	axr = Axis(f[1,1]; title="Density", shared..., ylabel="z (km)",
			   xlabel="ρ (kg/m³)", xticks=0:0.4:1.2, xminorticks=IntervalsBetween(4))
	lines!(axr, 1.2 .* exp.(-1000z ./ H), z, linewidth=2, color=:plum4)
	scatter!(axr, ρ, z, color=(:plum4, .5))
	
	axp = Axis(f[1,2]; shared..., title="Pressure",
		   xlabel="P (kPa)",  xminorticks=IntervalsBetween(5),  yticklabelsvisible=false, )
	lines!(axp, 101.325 .* exp.(-1000z ./ H), z, linewidth=2, color=:goldenrod3)
	scatter!(axp, P, z, color=(:goldenrod3, .5))
	
	axT = Axis(f[1,3]; shared..., title="Temperature", xlabel="T (°C)", xticks=-80:40:0, xminorticks=IntervalsBetween(4), )
	scatterlines!(axT, T, z, color=:firebrick4,)

	linkyaxes!(axp, axr, axT)
	Makie.save("rho-P-z.svg",f)

	for i=(axp, axr, axT)
		hlines!(i, 12, color=(:black, .7), linestyle=:dash )
	end
	ylims!(nothing,35)
	
	text!(axp, "Tropopause ~ 12 km", position=(25, 13), fontsize=16)
	Makie.save("rho-P-T-tropo.svg",f)
	
	f
end

# ╔═╡ e1236cbd-d83d-40aa-9850-a564e944cd7f


# ╔═╡ b87c3625-4157-49b5-800b-07d0b4182073
with_theme(dark_mode()) do

	N_(x) = @.  No * exp(-log(2)x)

No = 1

f=Figure(size=(800,400))
ax1= Axis(f[1,1], xlabel = "Half-lives",ylabel="Abundance", yticks=([0,1], ["0","Nₒ"]),ygridvisible=true)
t = 0:.1:6
N = lines!(ax1,t,N_(t), color=:hotpink)
n = lines!(ax1,t, No .- N_(t), linestyle=:dash, color=:cadetblue1)
	
Legend(f[1, 1], [N, n], ["N", "n"], halign=:right,tellwidth=false, tellheight=false, margin= (0,60,0,0,),framevisible=false)

Label(f[1,2],  L"\frac{n}{N}", color=:white, tellheight=false, tellwidth=true, fontsize=24 )
	
ax2= Axis(f[1,3], xlabel = "Half-lives",ylabelrotation=0,ygridvisible=true,xgridvisible=true,yticks= No ./ N_(0:4) .-1)
t = 0:.1:4
lines!(ax2,t,(No ./ N_(t)) .- 1, color=:seagreen1)
	
#Label(f[0,1], "a.", halign=:left,tellwidth=false, tellheight=true, font=:bold, fontsize=22)
#Label(f[0,2], "b.", font=:bold, halign=:left,fontsize=22,tellwidth=false, tellheight=true)
#rowsize!(f.layout,0,Relative(1/100))
Makie.save("../caves/nN-halflife.svg",f)
f
end

# ╔═╡ a608fa69-f8b4-4618-ab09-caa99e6b6430
with_theme(dark_mode()) do

	l238 = 1.551254796141587e-10
	l234 = 2.822030700105632e-6
	l230 = 9.170554357535262e-6

	n_N(x,l) = @. (exp(x * l) - 1) / exp(x * -l)


	f=Figure(size=(900,300))
	ax1= Axis(f[1,2], ylabelrotation=0, ygridvisible=false, xgridvisible=false, xlabel="Million years") 
		#"²⁰⁶Pb / ²³⁸U"
	Label(f[1,1], L"\frac{^{206}\text{Pb}}{^{238}\text{U}}", tellwidth=true, tellheight=false, color=:white)
		
	t = LinRange(0,5e9,200)
	lines!(ax1,t./1e6,n_N(t,l238), color=:hotpink)
	vlines!(ax1,4568, linestyle=:dash, color=:white, label="Age of solar system")
	axislegend(ax1, framevisible=false, position=(0,1), labelsize=18)
	
	
	Label(f[1,3], L"\frac{^{230}\text{Th}}{^{234}\text{U}}", tellwidth=true, tellheight=false, color=:white)
	
	
	dN2_dt(λ2::Number, λ1::Number, N2::Number ,N1::Number) = λ1 * N1 - λ2 * N2
	
	t = 1:5e5
	u238, u234, th230 = ((fill(NaN, length(t)) for i=1:3)...,)
	u238[1] = 1.
	u234[1] = l238/l234
	th230[1] = 0.
	
	for i = 2:length(t)
		u8, u4, th0 = u238[i-1], u234[i-1], th230[i-1]
		
		th0 += dN2_dt(l230,l234,th0,u4)*step(t) 
		u4 += dN2_dt(l234,l238,u4,u8)*step(t)
		u8 += -l238*step(t) 

		u238[i], u234[i], th230[i] = u8, u4, th0
	end 
	
	ax2= Axis(f[1,4], ygridvisible=false, xgridvisible=false, xlabel="Thousand years")
	lines!(ax2,t/1e3 , th230 ./ u234 , color=:cadetblue1)
	vlines!(ax2,71, linestyle=:dash, color=:white, label="Time since last\n ice age began")
	axislegend(ax2, framevisible=false, position=(1,0), labelsize=18)
	
	Makie.save("../caves/u-decays.svg",f)
	f
end

# ╔═╡ d5b87e70-d97a-43ae-9de4-3a57746ba765
with_theme(dark_mode()) do
	rdexp = [255, 290, 312, 372, 410, 456, 526, 646, 763, 904, 1081, 1275, 1474, 1715, 1921, 2149, 2225, 2335, 2500, 2630, 2884, 3023, 3409, 3729, 4067, 4625, 5366, 6063, 6847, 7324, 7882, 8620, 9687, 10928, 12153, 13463, 14979, 16290, 17589, 18821, 19954, 21035, 22179, 23055, 24380, 25867, 27544, 30084, 32801, 36383, 41470, 44839, 47535, 49645, 51590, 54114, 57288, 61287, 65274, 65873, 67109, 67313, 68664, 71880, 75293, 79176, 83646, 86444, 89840, 97835, 108841] .*1e-3
	t = 1953:2023
	@assert length(rdexp) == length(t)

	f = Makie.Figure()
	ax = Makie.Axis(f[1,1], xlabel="Year", ylabel="Annual expenditure (billion USD)")
	Makie.lines!(ax,t, rdexp, color=:turquoise1, linewidth=3)
	Makie.save("../war/total-rde.svg",f)
	f
end

# ╔═╡ 86c37f67-4ca0-43cb-a39e-05f2c20ba3ca
let 
	lr04 = DelimitedFiles.readdlm(Downloads.download("https://lorraine-lisiecki.com/LR04stack.txt"), '\t', skipstart=5)
	x, y = lr04[:,1], lr04[:,2]

	f = Makie.Figure(size=(600,200))
	ax = Makie.Axis(f[1,1], xlabel="Age (ka)", ylabel = "Benthic δ¹⁸O (‰)", xreversed=true, yreversed=true)

	lines!(ax, x,y, color=:black)
	Makie.save("lr04-full.svg",f)
	f
end

# ╔═╡ 9c8e2313-ff71-472a-849a-29709fe13c84
md"# Zachos plots"

# ╔═╡ 8229d4c8-6230-426e-87ee-ed819200af32
function numnan(x::Vector)
    o = Vector{Float64}(undef,length(x))
    @inbounds for i = eachindex(x)
        xi = x[i]
        o[i] = ifelse(xi isa Number, xi, NaN)
    end
    o
end

# ╔═╡ 0861d36e-04f5-4ca1-ad82-907897f00cce
function runmean(x::Vector, n::Int)
    o = fill(NaN,length(x))
    hnh = cld(n,2)
    hnl = hnh-1
    
	@inbounds for i = hnh:length(x)-hnh

		xv = view(x, i-hnl:i+hnl)

		nnm = nm = 0
		@inbounds @simd for i = eachindex(xv)
			xisnan = isnan(xv[i])
			nm += ifelse(xisnan, 0, xv[i])
			nnm += ifelse(xisnan, 0, 1)
		end
        o[i]= nm/nnm
    end
    o
end

# ╔═╡ 642521ca-7d11-4634-ba26-dfb573bfa222
begin
	zachos = readdlm("zachos.csv", ',')
	
	age = numnan(zachos[2:end,2])
	
	delO = numnan(zachos[2:end,4])
	delC = numnan(zachos[2:end,5])
end

# ╔═╡ a46c103e-4e02-4b18-aea6-a939019ad227
let 
    f = Figure(size=(800,400))
    	ax = Axis(f[1,1], yreversed=true, xreversed=true, ylabelsize=24, yticklabelsize=22, xlabelsize=24, xticklabelsize=22, xlabel="Age (Ma)", ylabel="Benthic δ¹⁸O (‰)")
    lines!(ax,age, runmean(delO,20), color=:black, linewidth=2)
    save("zachos-ox.svg",f)
    f
end

# ╔═╡ 01c586ba-1015-466f-a4e6-09be816bff54
let 
	kw = (; yreversed=true, xreversed=true, ylabelsize=24, yticklabelsize=20, xlabelsize=24, xticklabelsize=20,)
    petm=14550:14700
    ac = age[petm] .+ 0.8
    f = Figure(size=(600,500))
    ax1 = Axis(f[1,1]; kw..., ylabel="Age (Ma)", xlabel="Benthic δ¹⁸O (‰)")
    ax2 = Axis(f[1,2]; kw..., yticklabelsvisible=false, yticksvisible=false, xlabel="Benthic δ¹³C (‰)")
    lines!(ax1,runmean(delO[petm],20),ac,color=:black, linewidth=2)
    lines!(ax2,runmean(delC[petm],20), ac,color=:black, linewidth=2)
    save("petm.svg",f)
    f
end

# ╔═╡ bb26c787-f359-4a85-b315-324f15aec190
let 
	kw = (; yreversed=true, xreversed=true, ylabelsize=24, yticklabelsize=20, xlabelsize=24, xticklabelsize=20, yminorgridvisible=true, yminorticks=IntervalsBetween(5))
    petm=14585:14655
    ac = age[petm] .+ 0.8
    f = Figure(size=(600,500))
    ax1 = Axis(f[1,1]; kw..., ylabel="Age (Ma)", xlabel="Benthic δ¹⁸O (‰)")
    ax2 = Axis(f[1,2]; kw..., xlabel="Benthic δ¹³C (‰)", yticksvisible=false, yticklabelsvisible=false)
    lines!(ax1,runmean(delO[petm],20),ac,color=:black, linewidth=2)
    lines!(ax2,runmean(delC[petm],20), ac,color=:black, linewidth=2)
    save("petm-zoom.svg",f)
    f
end

# ╔═╡ Cell order:
# ╠═c6ac4680-7df6-11f0-1c46-a372ada2784f
# ╟─39aae521-e376-487b-bc06-6862558361fe
# ╠═1e65e687-75c8-43ce-811b-a88c102f78d6
# ╠═c6414566-5cf0-48ca-ac65-8559ce6c01e0
# ╠═c2f7b905-6b61-43ee-9830-636e8abc885b
# ╠═e1236cbd-d83d-40aa-9850-a564e944cd7f
# ╠═b87c3625-4157-49b5-800b-07d0b4182073
# ╠═a608fa69-f8b4-4618-ab09-caa99e6b6430
# ╠═d5b87e70-d97a-43ae-9de4-3a57746ba765
# ╠═86c37f67-4ca0-43cb-a39e-05f2c20ba3ca
# ╟─9c8e2313-ff71-472a-849a-29709fe13c84
# ╠═8229d4c8-6230-426e-87ee-ed819200af32
# ╠═0861d36e-04f5-4ca1-ad82-907897f00cce
# ╠═642521ca-7d11-4634-ba26-dfb573bfa222
# ╠═a46c103e-4e02-4b18-aea6-a939019ad227
# ╠═01c586ba-1015-466f-a4e6-09be816bff54
# ╠═bb26c787-f359-4a85-b315-324f15aec190
