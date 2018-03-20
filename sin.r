#!/usr/bin/env Rscript
# Verilog sin ROM
n <- 32
m <- 8-1
cat(paste("reg [", m,":0" ,"] sin [0:",n-1,"];\n", sep=""))
cat("initial begin\n")
a <- floor((1+sin((0:n)*2*pi/n))*(2^m-1))
if (T) { # Hex
	for (i in 1:(length(a)-1)){
		cat(paste("  sin[",i-1  ,"] = ", 2, "'h",
		format(as.hexmode(a[i+1]),upper.case=T, width=2, flag="0"),
			sep=''), ';\n',sep='')
	}
} else { # Binary
	for (i in 1:(length(a)-1)){
		cat(paste("  sin[",i-1  ,"] = ", 8, "'b",
			substr(paste(rev(as.integer(intToBits(a[i+1]))), collapse=''),
			n-8+1,n), ";\n", sep=""))
	}
}
if (F){ # Aggregate requires SystemVerilog
	cat(paste("  sin = {", sep=""))
	for (i in 1:(length(a)-1)){
		if (((i-1) %% 8 == 0) && (i<(length(a)-1)) ){
			cat("\n    ")
		}
		cat(paste(2, "'h",
			format(as.hexmode(a[i+1]),upper.case=T, width=2, flag="0"),
			sep=''),sep='')
		if (i<(length(a)-1)){
			cat(", ")
		}
	}
	cat("};\n")
}

cat("end\n")
