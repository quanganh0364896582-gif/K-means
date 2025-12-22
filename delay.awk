{
    event = $1; 
    time = $2; 
    node_to = $4; 
    fid = $8; 
    pkt_id = $12;

    # Bước 1: Ghi nhận thời điểm gói tin được gửi đi (event 's')
    if (event == "s" || event == "+") {
        send_time[pkt_id] = time;
    }

    # Bước 2: Ghi nhận thời điểm gói tin về đến ĐÍCH (event 'r')
    # Chúng ta lọc theo Flow ID để đảm bảo bắt đúng các luồng đã khai báo
    if (event == "r" && (fid >= 1 && fid <= 4)) {
        if (send_time[pkt_id] > 0) {
            delay = time - send_time[pkt_id];
            total_delay[fid] += delay;
            count[fid]++;
        }
    }
}

END {
    print "\n--- KẾT QUẢ PHÂN TÍCH ĐỘ TRỄ (DELAY) ---"
    found = 0;
    for (i = 1; i <= 4; i++) {
        if (count[i] > 0) {
            printf "Luồng (Flow ID) %d: Độ trễ trung bình = %.6f giây\n", i, total_delay[i] / count[i];
            found = 1;
        }
    }
    
    if (found == 0) {
        print "LỖI: Vẫn không tìm thấy gói tin nào về đích.";
        print "Gợi ý: Kiểm tra file .tr bằng lệnh 'tail project.tr' để xem các dòng cuối cùng.";
    }
}