// Proxy Management Frontend JS for SZ50 AIR

(function() {
  const toggleEl = document.getElementById('proxy-toggle');
  const statusTextEl = document.getElementById('proxy-status-text');
  const metricNode = document.getElementById('metric-node');
  const metricProto = document.getElementById('metric-proto');
  const metricMode = document.getElementById('metric-mode');
  const metricModeSub = document.getElementById('metric-mode-sub');
  const metricServer = document.getElementById('metric-server');
  const metricPort = document.getElementById('metric-port');
  const metricLatency = document.getElementById('metric-latency');
  const metricLatencyStatus = document.getElementById('metric-latency-status');
  const metricMemory = document.getElementById('metric-memory');
  const alertEl = document.getElementById('proxy-alert');

  // Mode cards
  const modeCardBypass = document.getElementById('mode-card-bypass');
  const modeCardGlobal = document.getElementById('mode-card-global');
  const radioBypass = document.getElementById('radio-mode-bypass');
  const radioGlobal = document.getElementById('radio-mode-global');

  // Tabs
  const tabBtnLink = document.getElementById('tab-btn-link');
  const tabBtnSub = document.getElementById('tab-btn-sub');
  const paneLink = document.getElementById('import-pane-link');
  const paneSub = document.getElementById('import-pane-sub');

  // Inputs & Buttons
  const nodeInput = document.getElementById('node-link-input');
  const subUrlInput = document.getElementById('sub-url-input');
  const saveBtn = document.getElementById('btn-save-node');
  const clearBtn = document.getElementById('btn-clear-node');
  const fetchSubBtn = document.getElementById('btn-fetch-sub');
  const testBtn = document.getElementById('btn-test-latency');
  const pingAllBtn = document.getElementById('btn-ping-all');
  const clearAllBtn = document.getElementById('btn-clear-all');

  // Node list
  const nodeCountEl = document.getElementById('node-count');
  const nodesContainer = document.getElementById('nodes-container');

  // Parsed details
  const parsedDetails = document.getElementById('parsed-details');
  const dtProto = document.getElementById('dt-proto');
  const dtName = document.getElementById('dt-name');
  const dtHost = document.getElementById('dt-host');
  const dtPort = document.getElementById('dt-port');

  // Bypass list elements
  const bypassTextarea = document.getElementById('bypass-textarea');
  const saveBypassBtn = document.getElementById('btn-save-bypass');
  const clearBypassBtn = document.getElementById('btn-clear-bypass');
  const bypassCountEl = document.getElementById('bypass-count');
  const bypassTagsContainer = document.getElementById('bypass-tags-container');

  let isUpdating = false;
  let currentNodes = [];
  let activeNodeId = '';
  let currentBypassList = [];
  let bypassInputDirty = false;

  function showAlert(msg) {
    if (!msg) {
      alertEl.hidden = true;
      alertEl.textContent = '';
      return;
    }
    alertEl.hidden = false;
    alertEl.textContent = msg;
  }

  async function loadStatus() {
    try {
      const res = await fetch('/air-api/proxy', { cache: 'no-store' });
      if (!res.ok) throw new Error('读取状态失败: ' + res.status);
      const data = await res.json();
      renderStatus(data);
    } catch (e) {
      showAlert('无法连接至代理服务接口: ' + e.message);
    }
  }

  function renderStatus(data) {
    isUpdating = true;
    toggleEl.checked = !!data.enabled;
    isUpdating = false;

    if (data.enabled) {
      if (data.running) {
        statusTextEl.textContent = '运行中';
        statusTextEl.className = 'status-pill status-on';
      } else {
        statusTextEl.textContent = '异常中断';
        statusTextEl.className = 'status-pill status-transition';
      }
    } else {
      statusTextEl.textContent = '已停用';
      statusTextEl.className = 'status-pill status-off';
    }

    // Routing mode
    const mode = data.routing_mode || 'bypass_cn';
    if (mode === 'bypass_cn') {
      radioBypass.checked = true;
      modeCardBypass.classList.add('active');
      modeCardGlobal.classList.remove('active');
      metricMode.textContent = '智能分流';
      metricModeSub.textContent = '绕过大陆 IP 与域名';
    } else {
      radioGlobal.checked = true;
      modeCardGlobal.classList.add('active');
      modeCardBypass.classList.remove('active');
      metricMode.textContent = '全局代理';
      metricModeSub.textContent = '全部外网流量代理';
    }

    metricNode.textContent = data.node_name || '未配置节点';
    metricProto.textContent = data.protocol ? data.protocol.toUpperCase() : '--';
    if (metricServer) metricServer.textContent = data.server || '--';
    if (metricPort) metricPort.textContent = data.port ? `端口 ${data.port}` : '--';

    if (data.memory_rss_kb > 0) {
      const mb = (data.memory_rss_kb / 1024).toFixed(1);
      metricMemory.textContent = mb + ' MB';
    } else {
      metricMemory.textContent = data.running ? '< 35 MB' : '--';
    }

    if (data.latency_ms > 0) {
      metricLatency.textContent = data.latency_ms + ' ms';
      metricLatencyStatus.textContent = '连接通畅';
    } else if (data.latency_ms === -1) {
      metricLatency.textContent = '超时';
      metricLatencyStatus.textContent = '连接失败';
    }

    if (data.last_error) {
      showAlert('运行错误: ' + data.last_error);
    } else {
      showAlert('');
    }

    // Nodes
    currentNodes = data.nodes || [];
    activeNodeId = data.active_node_id || '';
    renderNodeList(currentNodes, activeNodeId);

    // Active node details
    if (data.node_link) {
      if (!nodeInput.value && currentNodes.length <= 1) {
        nodeInput.value = data.node_link;
      }
      parsedDetails.hidden = false;
      dtProto.textContent = (data.protocol || '').toUpperCase();
      dtName.textContent = data.node_name || '';
      dtHost.textContent = data.server || '';
      dtPort.textContent = data.port || '';
    } else {
      parsedDetails.hidden = true;
    }

    // Bypass List
    currentBypassList = data.bypass_list || [];
    renderBypassTags(currentBypassList);
    if (bypassTextarea && !bypassInputDirty && document.activeElement !== bypassTextarea) {
      bypassTextarea.value = currentBypassList.join('\n');
    }
  }

  function renderBypassTags(list) {
    if (!bypassCountEl || !bypassTagsContainer) return;
    bypassCountEl.textContent = String(list.length);
    if (!list || list.length === 0) {
      bypassTagsContainer.innerHTML = '<span class="empty-hint">暂未配置排除项，所有非大陆流量（智能分流）或全部流量（全局）将走代理</span>';
      return;
    }
    bypassTagsContainer.innerHTML = '';
    list.forEach(item => {
      const tag = document.createElement('span');
      const isIP = /^[\d\.\/]+$/.test(item) || item.includes(':');
      tag.className = 'bypass-tag' + (isIP ? ' bypass-tag-ip' : '');
      tag.innerHTML = `<span>${escapeHtml(item)}</span><button type="button" class="bypass-tag-del" data-item="${escapeHtml(item)}" title="移除此项">×</button>`;
      tag.querySelector('.bypass-tag-del').addEventListener('click', async (e) => {
        e.stopPropagation();
        await removeBypassItem(item);
      });
      bypassTagsContainer.appendChild(tag);
    });
  }

  async function saveBypassList(list) {
    if (saveBypassBtn) {
      saveBypassBtn.disabled = true;
      saveBypassBtn.textContent = '保存中…';
    }
    try {
      const res = await fetch('/air-api/proxy/bypass', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ bypass_list: list })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '保存失败');
      bypassInputDirty = false;
      await loadStatus();
      showAlert('代理排除名单已保存并即刻生效！');
      setTimeout(() => showAlert(''), 3000);
    } catch (e) {
      showAlert('保存排除名单失败: ' + e.message);
    } finally {
      if (saveBypassBtn) {
        saveBypassBtn.disabled = false;
        saveBypassBtn.textContent = '💾 保存排除名单';
      }
    }
  }

  async function removeBypassItem(itemToRemove) {
    const updated = currentBypassList.filter(it => it !== itemToRemove);
    if (bypassTextarea) {
      bypassTextarea.value = updated.join('\n');
    }
    await saveBypassList(updated);
  }

  function renderNodeList(nodes, activeId) {
    nodeCountEl.textContent = String(nodes.length);
    if (!nodes || nodes.length === 0) {
      nodesContainer.innerHTML = '<div class="empty-nodes">暂无节点，请在上方粘贴链接或输入订阅进行添加</div>';
      return;
    }

    nodesContainer.innerHTML = '';
    nodes.forEach(node => {
      const nodeId = node.id || node.ID || '';
      const nodeName = node.name || node.Name || '未命名节点';
      const nodeProto = node.protocol || node.Protocol || 'vless';
      const nodeServer = node.server || node.Server || '';
      const nodePort = node.port || node.Port || 0;
      const nodeLatency = node.latency_ms !== undefined ? node.latency_ms : (node.LatencyMS !== undefined ? node.LatencyMS : 0);

      const item = document.createElement('div');
      const isActive = nodeId && nodeId === activeId;
      item.className = 'node-item' + (isActive ? ' is-active' : '');
      item.dataset.id = nodeId;

      const protoClass = 'badge-' + nodeProto.toLowerCase();
      let latencyHtml = '<span class="latency-tag">未测试</span>';
      if (nodeLatency > 0) {
        const cls = nodeLatency < 200 ? 'latency-good' : nodeLatency < 500 ? 'latency-fair' : 'latency-bad';
        latencyHtml = `<span class="latency-tag ${cls}">${nodeLatency} ms</span>`;
      } else if (nodeLatency === -1) {
        latencyHtml = '<span class="latency-tag latency-bad">超时</span>';
      }

      item.innerHTML = `
        <div class="node-left">
          <div class="active-radio" title="${isActive ? '当前使用中' : '点击选择此节点'}" data-id="${nodeId}"></div>
          <span class="proto-badge ${protoClass}">${nodeProto.toUpperCase()}</span>
          <div class="node-info-text">
            <span class="node-name-text" title="点击重命名">${escapeHtml(nodeName)}</span>
            <span class="node-endpoint-text">${escapeHtml(nodeServer)}:${nodePort}</span>
          </div>
        </div>
        <div class="node-right">
          ${latencyHtml}
          ${isActive ? '<span class="in-use-tag">使用中</span>' : `<button type="button" class="node-btn btn-select" data-id="${nodeId}">使用</button>`}
          <button type="button" class="node-btn btn-rename" data-id="${nodeId}" data-name="${escapeHtml(nodeName)}" title="重命名">✏️</button>
          <button type="button" class="node-btn btn-ping" data-id="${nodeId}" title="测速">⚡</button>
          <button type="button" class="node-btn node-del-btn btn-del" data-id="${nodeId}" title="删除">🗑️</button>
        </div>
      `;

      // Click to select node
      item.addEventListener('click', function(e) {
        if (e.target.closest('button')) return;
        if (e.target.closest('.node-name-text')) return;
        if (!isActive && nodeId) {
          selectNode(nodeId);
        }
      });

      // Quick rename on clicking node name text
      const nameTextEl = item.querySelector('.node-name-text');
      if (nameTextEl) {
        nameTextEl.addEventListener('click', (e) => {
          e.stopPropagation();
          renameNode(nodeId, nodeName);
        });
      }

      nodesContainer.appendChild(item);
    });

    // Attach button listeners
    nodesContainer.querySelectorAll('.btn-select').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        selectNode(btn.dataset.id);
      });
    });
    nodesContainer.querySelectorAll('.btn-rename').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        renameNode(btn.dataset.id, btn.dataset.name);
      });
    });
    nodesContainer.querySelectorAll('.btn-ping').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        pingNode(btn.dataset.id);
      });
    });
    nodesContainer.querySelectorAll('.btn-del').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        deleteNode(btn.dataset.id);
      });
    });
  }

  function escapeHtml(str) {
    if (!str) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  async function selectNode(id) {
    if (!id) {
      showAlert('切换节点失败: 缺少节点 ID');
      return;
    }
    showAlert('正在切换节点…');
    try {
      const res = await fetch('/air-api/proxy/node/select', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '切换失败');
      await loadStatus();
      showAlert('');
    } catch (e) {
      showAlert('切换节点失败: ' + e.message);
    }
  }

  async function renameNode(id, currentName) {
    if (!id) return;
    const newName = prompt('请输入新的节点名称：', currentName || '');
    if (!newName || newName.trim() === '' || newName.trim() === currentName) return;
    showAlert('正在重命名节点…');
    try {
      const res = await fetch('/air-api/proxy/node/rename', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id, name: newName.trim() })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '重命名失败');
      await loadStatus();
      showAlert('');
    } catch (e) {
      showAlert('重命名失败: ' + e.message);
    }
  }

  async function deleteNode(id) {
    if (!id) {
      showAlert('删除节点失败: 缺少节点 ID');
      return;
    }
    if (!confirm('确定要删除该节点吗？')) return;
    try {
      const res = await fetch('/air-api/proxy/node/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '删除失败');
      await loadStatus();
    } catch (e) {
      showAlert('删除节点失败: ' + e.message);
    }
  }

  async function pingNode(id) {
    const nodeEl = nodesContainer.querySelector(`[data-id="${id}"]`);
    if (nodeEl) {
      const tag = nodeEl.querySelector('.latency-tag');
      if (tag) tag.textContent = '测试中…';
    }
    try {
      const res = await fetch('/air-api/proxy/test', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
      });
      const data = await res.json();
      await loadStatus();
    } catch (e) {
      showAlert('测速失败: ' + e.message);
    }
  }

  async function switchRoutingMode(mode) {
    showAlert('正在更新分流模式…');
    try {
      const res = await fetch('/air-api/proxy/mode', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ mode })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '设置失败');
      await loadStatus();
      showAlert('');
    } catch (e) {
      showAlert('切换分流模式失败: ' + e.message);
    }
  }

  // Routing mode card clicks
  modeCardBypass.addEventListener('click', () => switchRoutingMode('bypass_cn'));
  modeCardGlobal.addEventListener('click', () => switchRoutingMode('global'));

  // Toggle switch
  toggleEl.addEventListener('change', async function() {
    if (isUpdating) return;
    const targetState = toggleEl.checked;
    statusTextEl.textContent = targetState ? '启动中...' : '停止中...';
    statusTextEl.className = 'status-pill status-transition';

    try {
      const res = await fetch('/air-api/proxy/toggle', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ enabled: targetState })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '操作失败');
      await loadStatus();
    } catch (e) {
      showAlert('切换代理状态失败: ' + e.message);
      toggleEl.checked = !targetState;
      statusTextEl.textContent = toggleEl.checked ? '运行中' : '已停用';
      statusTextEl.className = toggleEl.checked ? 'status-pill status-on' : 'status-pill status-off';
    }
  });

  // Tab switching
  tabBtnLink.addEventListener('click', () => {
    tabBtnLink.classList.add('active');
    tabBtnSub.classList.remove('active');
    paneLink.style.display = 'block';
    paneSub.style.display = 'none';
  });

  tabBtnSub.addEventListener('click', () => {
    tabBtnSub.classList.add('active');
    tabBtnLink.classList.remove('active');
    paneSub.style.display = 'block';
    paneLink.style.display = 'none';
  });

  // Save / Import text nodes
  saveBtn.addEventListener('click', async function() {
    const raw = nodeInput.value.trim();
    if (!raw) {
      showAlert('请粘贴节点分享链接或 Base64 订阅内容');
      return;
    }
    saveBtn.disabled = true;
    saveBtn.textContent = '正在解析与导入…';
    showAlert('');

    try {
      const res = await fetch('/air-api/proxy/node', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text: raw })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '导入失败');
      await loadStatus();
      showAlert(`成功导入 ${data.added_count || 1} 个节点`);
      setTimeout(() => showAlert(''), 3000);
    } catch (e) {
      showAlert('导入节点失败: ' + e.message);
    } finally {
      saveBtn.disabled = false;
      saveBtn.textContent = '添加并导入节点';
    }
  });

  // Fetch subscription URL
  fetchSubBtn.addEventListener('click', async function() {
    const subUrl = subUrlInput.value.trim();
    if (!subUrl) {
      showAlert('请输入有效的订阅链接');
      return;
    }
    fetchSubBtn.disabled = true;
    fetchSubBtn.textContent = '正在拉取…';
    showAlert('');

    try {
      const res = await fetch('/air-api/proxy/node', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ sub_url: subUrl })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || '拉取失败');
      await loadStatus();
      subUrlInput.value = '';
      showAlert(`订阅拉取成功！已导入 ${data.added_count || 0} 个节点（共 ${data.total_nodes} 个）`);
      setTimeout(() => showAlert(''), 4000);
    } catch (e) {
      showAlert('拉取订阅失败: ' + e.message);
    } finally {
      fetchSubBtn.disabled = false;
      fetchSubBtn.textContent = '拉取订阅';
    }
  });

  clearBtn.addEventListener('click', function() {
    nodeInput.value = '';
  });

  // Test current node latency
  testBtn.addEventListener('click', async function() {
    testBtn.disabled = true;
    metricLatency.textContent = '测试中...';
    metricLatencyStatus.textContent = '正在连接...';

    try {
      const res = await fetch('/air-api/proxy/test', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      });
      const data = await res.json();
      if (data.ok && data.latency_ms >= 0) {
        metricLatency.textContent = data.latency_ms + ' ms';
        metricLatencyStatus.textContent = '连接通畅';
      } else {
        metricLatency.textContent = '超时';
        metricLatencyStatus.textContent = data.error || '连接失败';
      }
      await loadStatus();
    } catch (e) {
      metricLatency.textContent = '失败';
      metricLatencyStatus.textContent = e.message;
    } finally {
      testBtn.disabled = false;
    }
  });

  // Ping all nodes
  pingAllBtn.addEventListener('click', async function() {
    pingAllBtn.disabled = true;
    pingAllBtn.textContent = '测速中…';
    try {
      await fetch('/air-api/proxy/test-all', { method: 'POST' });
      await loadStatus();
    } catch (e) {
      showAlert('全部测速失败: ' + e.message);
    } finally {
      pingAllBtn.disabled = false;
      pingAllBtn.textContent = '⚡ 全部测速';
    }
  });

  // Clear all nodes
  clearAllBtn.addEventListener('click', async function() {
    if (!confirm('确定要清空所有节点吗？清空后将停止代理转发。')) return;
    clearAllBtn.disabled = true;
    try {
      await fetch('/air-api/proxy/node/clear', { method: 'POST' });
      await loadStatus();
    } catch (e) {
      showAlert('清空节点失败: ' + e.message);
    } finally {
      clearAllBtn.disabled = false;
    }
  });

  // Bypass list event bindings
  if (bypassTextarea) {
    bypassTextarea.addEventListener('input', () => {
      bypassInputDirty = true;
    });
  }

  if (saveBypassBtn) {
    saveBypassBtn.addEventListener('click', async () => {
      const raw = bypassTextarea ? bypassTextarea.value : '';
      const items = raw.split(/[\r\n,]+/).map(s => s.trim()).filter(Boolean);
      await saveBypassList(items);
    });
  }

  if (clearBypassBtn) {
    clearBypassBtn.addEventListener('click', () => {
      if (bypassTextarea) {
        bypassTextarea.value = '';
      }
      bypassInputDirty = true;
    });
  }

  // Initial load & poll
  loadStatus();
  setInterval(function(){const _s=document.getElementById('proxyweb-section');if((!_s||!_s.hidden)&&!document.hidden)loadStatus();},15000);
})();
