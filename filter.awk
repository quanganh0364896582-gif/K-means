BEGIN {
    print "Time\tEvent\tFrom\tTo\tType\tSize\tFlowID"
}
{
    event = $1; time = $2; from = $3; to = $4; type = $5; size = $6; fid = $8;
    
    # Chỉ lọc các sự kiện s (gửi), r (nhận), d (loại bỏ)
    if (event == "s" || event == "r" || event == "d") {
        printf("%.4f\t%s\t%d\t%d\t%s\t%d\t%d\n", time, event, from, to, type, size, fid);
    }
}