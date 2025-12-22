BEGIN {
    # Khởi tạo mảng
    startTime = 1e6;
    stopTime = 0;
}
{
    event = $1; time = $2; node_to = $4; size = $6; fid = $8;

    # r = received tại Server (Node 6 trong kịch bản của bạn)
    if (event == "r" && node_to == 6) {
        if (time < startTime) startTime = time;
        if (time > stopTime) stopTime = time;
        
        # Tính tổng số bit cho mỗi luồng
        flow_bits[fid] += (size * 8);
    }
}
END {
    duration = stopTime - startTime;
    print "--- BÁO CÁO THÔNG LƯỢNG (THROUGHPUT) ---"
    for (id in flow_bits) {
        thr = flow_bits[id] / (duration * 1000); # Đơn vị Kbps
        printf "Flow ID %d: %.2f Kbps\n", id, thr;
    }
}